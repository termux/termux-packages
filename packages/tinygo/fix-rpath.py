#!/usr/bin/python3
import sys

if len(sys.argv) < 2:
    sys.exit()

rpath = sys.argv[1]
ld_lld_argv = sys.argv[2:]

count = 0
while rpath in ld_lld_argv:
    ld_lld_argv.remove(rpath)
    count = count + 1

if count > 0:
    ld_lld_argv.append(rpath)

if len(ld_lld_argv) > 0:
    print(" ".join(ld_lld_argv))
