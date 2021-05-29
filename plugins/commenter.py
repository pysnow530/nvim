#!/usr/bin/env python
# -*- coding: utf-8 -*-
import sys
import re
from functools import partial


__all__ = ['COMMENTER_CONFIG', 'toggle_block_comment']


COMMENTER_CONFIG = {'python': '#', 'vim': '"'}


def commenter_generator(comment):
    def commentter(nr_blank):
        return lambda line: re.sub(r'(\s{' + str(nr_blank) + '})', r'\1' + f'{comment} ', line, count=1).rstrip()
    return commentter


def uncommenter(comment):
    return partial(re.sub, r'(\s*)(' + comment + '\s?)', r'\1', count=1)


def commented(comment):
    return lambda line: re.match(r'\s*' + comment + '.*', line) is not None


def toggle_block_comment():
    import vim

    curr_buf = vim.current.buffer

    filetype = curr_buf.options['filetype'].decode('utf-8')
    comment_str = COMMENTER_CONFIG.get(filetype)
    if comment_str is None:
        sys.stderr.write(f'Unsupported filetype: {filetype}')
        return

    start, end = curr_buf.mark('[')[0] - 1, curr_buf.mark(']')[0]
    if all(map(commented(comment_str), curr_buf[start:end])):
        curr_buf[start:end] = list(map(uncommenter(comment_str), curr_buf[start:end]))
    else:
        nr_blank = min([re.search(r'\S', line).start() if line else 0 for line in curr_buf[start:end]])
        curr_buf[start:end] = list(map(commenter_generator(comment_str)(nr_blank), curr_buf[start:end]))


if __name__ == '__main__':
    assert commenter_generator('#')(2)('  hello') == '  # hello'
    assert commenter_generator('#')(0)('') == '#'
    assert uncommenter('#')('  # hello') == '  hello'
    assert commented('#')('  #hello') is True
    assert commented('#')('  # hello') is True
    assert commented('#')('"# hello"') is False
