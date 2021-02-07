#!/usr/bin/python3

"""
resizing png files to half size in height and length
"""

import sys
import os
from PIL import Image

def parse_arguments():
    files = []
    if len(sys.argv) > 1:
        for element in sys.argv[1:]: files.append(element)
    return files

def parse_stdinput():
    files = []
    if not sys.stdin.isatty():
        for line in sys.stdin:
            files.append(line.rstrip())
    return files

def check_extensions(files, extension):
    if files == []: return False
    for file in files:
        if file[-3:] != extension:
            return False
    return True

def resize_png(path):
    try:
        png = Image.open(path)
    except IOError:
        sys.stderr.write("exception: coudn't open " + path + "\n")
        sys.stderr.flush()
        sys.exit(1)

    width, height = png.size
    new_png = png.resize((int(width * .5), int(height * .5)))
    png.save(path[:-4] + '_' + str(width) + 'x' + str(height) + '.png')
    new_png.save(path)

def main():
    files = list(parse_arguments())
    if files == []:
        files = list(parse_stdinput())

    if not check_extensions(files, 'png'):
        sys.stderr.write("error: no valid files passed.\n")
    else:
        for file in files:
            resize_png(file)
            sys.stdout.write("success: made a backup and resized " + file + "\n")

if __name__ == "__main__":
    main()
