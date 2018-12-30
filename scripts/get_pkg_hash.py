#!/usr/bin/env python

import os, sys

def get_hash_from_Packages(Packages_file, package, hash="SHA256"):
    with open(Packages_file, 'r') as Packages:
        package_list = Packages.read().split('\n\n')
        for pkg in package_list:
            if pkg.split('\n')[0] == "Package: "+package:
                for line in pkg.split('\n'):
                    if line.startswith(hash):
                        print(line.split(" ")[1])
                        break
                break

if __name__ == '__main__':
    if len(sys.argv) < 2:
        print('Too few arguments, I need the path to a Packages file and a package name. Exiting')
        sys.exit(1)
    get_hash_from_Packages(sys.argv[1], sys.argv[2])
