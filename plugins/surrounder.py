#!/usr/bin/env python
# -*- coding: utf-8 -*-
import sys


CONFIG = ["''", '""', '()', '<>', '[]', '{}']


def surround():
    import vim

    curr_buf = vim.current.buffer
    charcode = vim.bindeval('getchar()')

    try:
        left_char, right_char = search_pair(chr(charcode), CONFIG)
    except ValueError as exc:
        sys.stderr.write(str(exc))
        sys.stderr.flush()
        return

    (row1, col1), (row2, col2) = curr_buf.mark('['), curr_buf.mark(']')
    curr_buf[row2-1] = curr_buf[row2-1][:col2+1] + right_char + curr_buf[row2-1][col2+1:]
    curr_buf[row1-1] = curr_buf[row1-1][:col1] + left_char + curr_buf[row1-1][col1:]


def unsurround():
    import vim

    curr_buf = vim.current.buffer
    charcode = vim.bindeval('getchar()')

    try:
        left_char, right_char = search_pair(chr(charcode), CONFIG)
    except ValueError as exc:
        sys.stderr.write(str(exc))
        sys.stderr.flush()
        return

    line = vim.current.line
    curr_row, curr_col = vim.current.window.cursor
    new_line = remove_pair(line, curr_col, left_char, right_char)
    if line != new_line:
        vim.current.line = new_line
        vim.current.window.cursor = (curr_row, curr_col-1)


def search_pair(char, pair_list):
    matches = [pair for pair in pair_list if char in pair]
    if len(matches) == 0:
        raise ValueError(f'Unsupport char {char}!')
    return matches[0]


def string_but(string, idx):
    return string[:idx] + string[idx+1:]


def remove_pair(string, idx, left_char, right_char):
    left_string, curr_char, right_string = string[:idx], string[idx], string[idx+1:]
    if (not left_string or not right_string
            or left_char not in left_string or right_char not in right_string):
        return string
    return (string_but(left_string, left_string.rindex(left_char))
            + curr_char
            + string_but(right_string, right_string.index(right_char)))


if __name__ == '__main__':
    assert search_pair('"', ['""']) == '""'

    assert string_but('hello', 0) == 'ello'
    assert string_but('hello', 1) == 'hllo'
    assert string_but('hello', 4) == 'hell'

    assert remove_pair('"hello"', 0, '"', '"') == '"hello"'
    assert remove_pair('"hello"', 1, '"', '"') == 'hello'
    assert remove_pair('"hello"', 6, '"', '"') == '"hello"'