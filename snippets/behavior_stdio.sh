#!/usr/local/bin/python

"""
typical behavior for a prog dealing with stdio
"""

import sys


def parse_arguments():
    files = []
    if len(sys.argv) > 1:
        for element in sys.argv[1:]: files.append(element)
    return files

# deal with stdinput
def parse_stdinput():
    files = []
    if not sys.stdin.isatty():
        for line in sys.stdin:
            files.append(line.rstrip())
    return files

files = list(parse_arguments())
if files == []:
    files = list(parse_stdinput())

print(files)
