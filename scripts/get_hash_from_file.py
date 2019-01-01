#!/usr/bin/env python

import os, sys

def get_pkg_hash_from_Packages(Packages_file, package, hash="SHA256"):
    with open(Packages_file, 'r') as Packages:
        package_list = Packages.read().split('\n\n')
    for pkg in package_list:
        if pkg.split('\n')[0] == "Package: "+package:
            for line in pkg.split('\n'):
                if line.startswith(hash):
                    print(line.split(" ")[1])
                    break
            break

def get_Packages_hash_from_InRelease(InRelease_file, arch, hash="SHA256"):
    string_to_found = 'binary-'+arch+'/Packages.xz'
    with open(InRelease_file, 'r') as InRelease:
        hash_list = InRelease.readlines()
    for i in range(len(hash_list)):
        if hash_list[i].startswith(hash+':'):
            break
    for j in range(i, len(hash_list)):
        if string_to_found in hash_list[j].strip(' '):
            print(hash_list[j].strip(' ').split(' ')[0])
            break

if __name__ == '__main__':
    if len(sys.argv) < 2:
        sys.exit('Too few arguments, I need the path to a Packages file and a package name. Exiting')

    if sys.argv[1].endswith('Packages'):
        get_pkg_hash_from_Packages(sys.argv[1], sys.argv[2])
    elif sys.argv[1].endswith('InRelease'):
        get_Packages_hash_from_InRelease(sys.argv[1], sys.argv[2])
    else:
        sys.exit(sys.argv[1]+' does not seem to be a path to a Packages or InRelease file')
