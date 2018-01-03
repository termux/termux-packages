#!/usr/bin/env python3

import os
import re
import sys

def main():
    package_dir = 'packages'
    for pkgdir_name in sorted(os.listdir(package_dir)):
        dir_path = package_dir + '/' + pkgdir_name
        build_sh_path = dir_path + '/build.sh'
        if not os.path.isfile(build_sh_path):
            sys.exit('No build.sh file in: ' + pkgdir_name)
        with open(build_sh_path) as build_sh:
            lines = build_sh.readlines()
        validate_package(pkgdir_name, lines)

def validate_package(package_name, lines):
    if len(lines) < 3:
        print('Too few lines in package: ' + package_name)
        return
    if not lines[0].startswith('TERMUX_PKG_HOMEPAGE='):
        print('The first line is not TERMUX_PKG_HOMEPAGE: ' + package_name)
    if not lines[1].startswith('TERMUX_PKG_DESCRIPTION='):
        print('The second line is not TERMUX_PKG_DESCRIPTION: ' + package_name)

    line_number = 1
    for line in lines:
        if line.endswith(' \n'):
            print(package_name + ': Line ' + str(line_number) + ' has trailing whitespace')
        if line.startswith('TERMUX_PKG_REVISION='):
            value = line[len('TERMUX_PKG_REVISION='):].strip()
            if not re.match('[0-9]+', value):
                print(package_name + ': strange TERMUX_PKG_REVISION value "' + value + '"')

        line_number += 1

if __name__ == '__main__':
    main()
