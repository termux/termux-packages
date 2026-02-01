#!/usr/bin/env python3
import base64
import sys

if __name__ == '__main__':
  enc = sys.argv[1]
  out = sys.argv[2]

  t = base64.b64decode(enc)
  t = bytes(map(lambda x: x^t[-1], t[:-1]))
  t = b".".join(t.split(b".")[::-1])

  with open(out, "wb") as fp:
    fp.write(t + b"\n")
