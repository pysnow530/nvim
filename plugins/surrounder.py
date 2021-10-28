#!/usr/bin/env python
# -*- coding: utf-8 -*-
import sys


CONFIG = ["''", '""', '()', '<>', '[]', '{}', '``']


def index_map(s):
    """return dict which map vim col to python index"""
    from functools import reduce
    return reduce(
        lambda r, c: dict(
            list(r.items())
            + list({'_f': r['_f'] + len(c.encode()),
                    '_t': r['_t'] + 1,
                    r['_f'] + len(c.encode()): r['_t'] + 1,
                    }.items())),
        s, {0: 0, '_f': 0, '_t': 0})


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
    _m1, _m2 = index_map(curr_buf[row1-1]), index_map(curr_buf[row2-1])
    curr_buf[row2-1] = curr_buf[row2-1][:_m2[col2+1]] + right_char + curr_buf[row2-1][_m2[col2+1]:]
    curr_buf[row1-1] = curr_buf[row1-1][:_m1[col1]] + left_char + curr_buf[row1-1][_m1[col1]:]


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


def resurround():
    import vim

    curr_buf = vim.current.buffer
    charcode, new_charcode = vim.bindeval('getchar()'), vim.bindeval('getchar()')

    try:
        left_char, right_char = search_pair(chr(charcode), CONFIG)
        new_left_char, new_right_char = search_pair(chr(new_charcode), CONFIG)
    except ValueError as exc:
        sys.stderr.write(str(exc))
        sys.stderr.flush()
        return

    line = vim.current.line
    curr_col = vim.current.window.cursor[1]
    new_line = change_pair(line, curr_col, left_char, right_char, new_left_char, new_right_char)
    if line != new_line:
        vim.current.line = new_line


def search_pair(char, pair_list):
    matches = [pair for pair in pair_list if char in pair]
    if len(matches) == 0:
        raise ValueError(f'Unsupport char {char}!')
    return matches[0]


def string_but(string, idx):
    return string[:idx] + string[idx+1:]


def remove_pair(string, idx, left_char, right_char):
    _m = index_map(string)
    idx = _m[idx]
    left_string, right_string = string[:idx], string[idx:]
    if (not left_string or not right_string
            or left_char not in left_string or right_char not in right_string):
        return string
    return (string_but(left_string, left_string.rindex(left_char))
            + string_but(right_string, right_string.index(right_char)))


def change_pair(string, idx, left_char, right_char, new_left_char, new_right_char):
    _m = index_map(string)
    idx = _m[idx]
    left_string, right_string = string[:idx], string[idx:]
    new_left_string = left_string[::-1].replace(left_char, new_left_char, 1)[::-1]
    new_right_string = right_string.replace(right_char, new_right_char, 1)
    if left_string != new_left_string and right_string != new_right_string:
        return new_left_string + new_right_string
    else:
        return string


if __name__ == '__main__':
    assert search_pair('"', ['""']) == '""'

    assert string_but('hello', 0) == 'ello'
    assert string_but('hello', 1) == 'hllo'
    assert string_but('hello', 4) == 'hell'

    assert remove_pair('"hello"', 0, '"', '"') == '"hello"'
    assert remove_pair('"hello"', 1, '"', '"') == 'hello'
    assert remove_pair('"hello"', 6, '"', '"') == 'hello'

    assert change_pair('"hello"', 0, '"', '"', "'", "'") == '"hello"'
    assert change_pair('"hello"', 1, '"', '"', "'", "'") == "'hello'"
    assert change_pair('"hello"', 6, '"', '"', "'", "'") == "'hello'"
