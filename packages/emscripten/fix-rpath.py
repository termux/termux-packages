#!/usr/bin/python3
import sys

rpath = sys.argv[1]
ld_lld_argv = sys.argv[2:]

if rpath in ld_lld_argv:
    ld_lld_argv.remove(rpath)
    ld_lld_argv.append(rpath)

print(" ".join(ld_lld_argv))
