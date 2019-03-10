#!/usr/bin/env python

import os, sys

def get_pkg_hash_from_Packages(Packages_file, package, version, hash="SHA256"):
    with open(Packages_file, 'r') as Packages:
        package_list = Packages.read().split('\n\n')
    for pkg in package_list:
        if pkg.split('\n')[0] == "Package: "+package:
            for line in pkg.split('\n'):
                # Assuming Filename: comes before Version:
                if line.startswith('Filename:'):
                    print(line.split(" ")[1] + " ")
                elif line.startswith('Version:'):
                    if line != 'Version: '+version:
                        # Seems the repo contains the wrong version, or several versions
                        # We can't use this one so continue looking
                        break
                elif line.startswith(hash):
                    print(line.split(" ")[1])
                    break

def get_Packages_hash_from_Release(Release_file, arch, component, hash="SHA256"):
    string_to_find = component+'/binary-'+arch+'/Packages'
    with open(Release_file, 'r') as Release:
        hash_list = Release.readlines()
    for i in range(len(hash_list)):
        if hash_list[i].startswith(hash+':'):
            break
    for j in range(i, len(hash_list)):
        if string_to_find in hash_list[j].strip(' '):
            print(hash_list[j].strip(' ').split(' ')[0])
            break

if __name__ == '__main__':
    if len(sys.argv) < 2:
        sys.exit('Too few arguments, I need the path to a Packages file, a package name and a version, or an InRelease file, an architecture and a component name. Exiting')

    if sys.argv[1].endswith('Packages'):
        get_pkg_hash_from_Packages(sys.argv[1], sys.argv[2], sys.argv[3])
    elif sys.argv[1].endswith(('InRelease', 'Release')):
        get_Packages_hash_from_Release(sys.argv[1], sys.argv[2], sys.argv[3])
    else:
        sys.exit(sys.argv[1]+' does not seem to be a path to a Packages or InRelease/Release file')
