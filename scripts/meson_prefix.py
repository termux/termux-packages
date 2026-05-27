#!/bin/env python3
import pickle
import sys

new = sys.argv[1]
filename = sys.argv[2]

try:
	with open(filename, 'rb') as f:
		obj = pickle.load(f)
	print("replacing prefix", obj.prefix, "with", new, "in", filename)
	obj.prefix = new
	with open(filename, 'wb') as f:
		pickle.dump(obj, f)
except Exception as e:
	print(e)
