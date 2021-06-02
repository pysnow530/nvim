#!/usr/bin/env python
# -*- coding: utf-8 -*-
import os
import sys
import re
from functools import partial

IGNORE_CONFIG = ['.*', '*.pyc']

CACHE = {}


def glob_match(pattern, string):
    if pattern == '':
        return len(string) == 0
    if string == '':
        return pattern == '*'
    if pattern[0] == '*':
        return glob_match(pattern, string[1:]) or glob_match(pattern[1:], string[1:])
    if pattern[0] != string[0]:
        return False
    return glob_match(pattern[1:], string[1:])


def treedir(dir, ignores=None):
    ignores = ignores or []
    items = os.listdir(dir)
    result = []
    for item in items:
        item = os.path.join(dir, item)
        if any([glob_match(i, os.path.basename(item)) for i in ignores]):
            continue
        if os.path.isfile(item):
            result.append(item)
        if os.path.isdir(item):
            result.extend(treedir(item, ignores=ignores))
        if len(result) > 5000:
            raise IOError('File is too much to tree, more than 5000!')
    return result


def fuzzy_match(needle, string):
    needle_segs, string_segs = re.split('/| ', needle), re.split('/| ', string)
    while needle_segs and string_segs:
        if needle_segs[0] in string_segs[0]:
            needle_segs = needle_segs[1:]
            string_segs = string_segs[1:]
        else:
            string_segs = string_segs[1:]
    return not needle_segs


def load_items(dir, search):
    if not search:
        CACHE[dir] = {'': [os.path.relpath(f, dir) for f in treedir(dir, IGNORE_CONFIG)]}
        return CACHE[dir]['']

    if search not in CACHE[dir]:
        last_cache_key = [search[:i] for i in range(0, len(search) + 1)[::-1] if search[:i] in CACHE[dir]][0]
        last_cache = CACHE[dir][last_cache_key]
        CACHE[dir][search] = [f for f in last_cache if fuzzy_match(search, f)]
        CACHE[dir][search] = list(filter(partial(fuzzy_match, search), last_cache))

    return CACHE[dir][search]


def ctrlp(new=False):
    import vim

    cwd = vim._getcwd()
    search = '' if new else vim.current.buffer[0]  # current buffer is not ctrlp window if new

    try:
        items = load_items(cwd, search)[:10] + (['...'] if len(load_items(cwd, search)) > 10 else [])
    except IOError as exc:
        sys.stderr.write(str(exc))
        sys.stderr.flush()
        return

    if new:
        vim.command('6new | set ft=ctrlp | startinsert')

    vim.current.buffer[1:] = items


def edit():
    import vim

    if vim.current.range.start == 0:
        vim.command(f'bdelete! | e {vim.current.buffer[1]}')
    else:
        vim.command(f'bdelete! | e {vim.current.line}')


def syntax():
    import vim

    vim.command('syntax clear')
    if vim.current.line:
        [vim.command(f'syntax match Keyword "{i}"')
         for i in re.split('/| ', vim.current.line) if i]


if __name__ == '__main__':
    assert glob_match('.*', '.ignore') is True
    assert glob_match('.*', 'hello.py') is False

    from tempfile import mkdtemp
    import shutil
    tempdir = mkdtemp()
    try:
        assert treedir(tempdir) == []
        os.mkdir(os.path.join(tempdir, 'aaa'))
        assert treedir(tempdir) == []
        os.mkdir(os.path.join(tempdir, 'bbb'))
        open(os.path.join(tempdir, 'bbb/ccc'), 'w+').write('hello')
        assert treedir(tempdir) == [os.path.join(tempdir, 'bbb/ccc')]

        assert load_items(tempdir, '') == ['bbb/ccc']
        assert load_items(tempdir, 'ccc') == ['bbb/ccc']
        assert load_items(tempdir, 'aaa') == []
    finally:
        shutil.rmtree(tempdir)

    assert fuzzy_match('', 'hello') is True
    assert fuzzy_match('he', 'hello') is True
    assert fuzzy_match('ho', 'hello') is False
    assert fuzzy_match('he/ld', 'hello/world') is True
    assert fuzzy_match('he/wld', 'hello/world') is False

    load_items('/Users/oogwu/.vim', '')
    load_items('/Users/oogwu/.vim', 'v')
