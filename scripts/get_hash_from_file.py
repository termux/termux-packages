#!/usr/bin/env python3

import sys
import os

def get_pkg_hash_from_Packages(Packages_file, package, version, hash_type="SHA256"):
    with open(Packages_file, 'r') as Packages:
        package_list = Packages.read().split('\n\n')
    
    for pkg in package_list:
        lines = pkg.split('\n')
        if lines[0].strip() == "Package: " + package:
            for line in lines:
                line = line.strip()
                if line.startswith('Filename:'):
                    # Print the filename
                    print(line.split(None, 1)[1], end=" ")
                elif line.startswith('Version:'):
                    if os.getenv('TERMUX_WITHOUT_DEPVERSION_BINDING') != 'true' and line.strip() != 'Version: ' + version:
                        # Wrong version, skip this package
                        break
                elif line.startswith(hash_type):
                    # Print the hash
                    print(line.split(None, 1)[1])
                    return  # Found the package, stop searching

def get_Packages_hash_from_Release(Release_file, arch, component, hash_type="SHA256"):
    string_to_find = f"{component}/binary-{arch}/Packages"
    
    with open(Release_file, 'r') as Release:
        hash_list = Release.readlines()
    
    # Find the start of the hash section
    start_index = 0
    for i, line in enumerate(hash_list):
        if line.startswith(hash_type + ':'):
            start_index = i
            break
    
    # Search for the line matching our Packages file
    for j in range(start_index, len(hash_list)):
        line = hash_list[j].strip()
        if string_to_find in line and string_to_find + "." not in line:
            hash_entry = list(filter(None, line.split()))
            if len(hash_entry) >= 3 and hash_entry[2].startswith(".work_"):
                continue
            print(hash_entry[0])
            return  # Found the hash, stop searching

if __name__ == '__main__':
    if len(sys.argv) < 4:
        sys.exit(
            'Too few arguments. Provide either:\n'
            '1) Packages file path, package name, version\n'
            '2) Release/InRelease file path, architecture, component name'
        )

    input_file = sys.argv[1]

    if input_file.endswith('Packages'):
        get_pkg_hash_from_Packages(input_file, sys.argv[2], sys.argv[3])
    elif input_file.endswith(('InRelease', 'Release')):
        get_Packages_hash_from_Release(input_file, sys.argv[2], sys.argv[3])
    else:
        sys.exit(f"{input_file} does not seem to be a Packages or InRelease/Release file")
