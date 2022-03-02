#!/usr/bin/python3

import sys
import time

while True:
    for char in ['-', '\\', '|', '/']:
        #sys.stdout.write("\r%c" % char)
        #sys.stdout.flush()
        print("\r", char, sep="", end="", flush=True, file=sys.stdout)
        time.sleep(1)

