#!/usr/bin/env python
# -*- coding: utf-8 -*-
import sys
import re


def std_matrix(matrix, default=None):
    length = max(map(len, matrix))
    return [row + [default] * (length - len(row)) for row in matrix]


def transpose(matrix):
    return [[row[i] for row in matrix] for i in range(len(matrix[0]))]


def fix_width(matrix, strwidth):
    widths = [max(map(strwidth, col)) for col in transpose(matrix)]
    return [[item + ' ' * (widths[idx] - strwidth(item)) for idx, item in enumerate(row)] for row in matrix]


def tabular():
    import vim

    sep, start, end = vim.eval('[a:sep, a:start, a:end]')
    start, end = int(start) - 1, int(end)

    if not sep.startswith('/'):
        sys.stderr.write('Support regex only, start with /')
        sys.stderr.flush()
        return

    try:
        split = re.compile(sep[1:]).split
    except re.error:
        sys.stderr.write(f'regexp invalid: {str(re.error)}')
        sys.stderr.flush()
        return

    curr_buf = vim.current.buffer

    matrix = std_matrix(list(map(split, curr_buf[start:end])), '')
    print(matrix)

    curr_buf[start:end] = list(map(' '.join, fix_width(matrix, vim.strwidth)))


if __name__ == '__main__':
    assert std_matrix([[1, 2], [3], [4]]) == [[1, 2], [3, None], [4, None]]
    assert transpose([[1, 2], [3, 4]]) == [[1, 3], [2, 4]]
    assert fix_width([['hello', 'world'], ['foo', 'bar']], len) == [['hello', 'world'], ['foo  ', 'bar  ']]
