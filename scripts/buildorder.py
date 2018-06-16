#!/usr/bin/env python3
"Script to generate a build order respecting package dependencies."

import os
import re
import sys

from itertools import filterfalse

def unique_everseen(iterable, key=None):
    """List unique elements, preserving order. Remember all elements ever seen.
    See https://docs.python.org/3/library/itertools.html#itertools-recipes
    Examples:
    unique_everseen('AAAABBBCCDAABBB') --> A B C D
    unique_everseen('ABBCcAD', str.lower) --> A B C D"""
    seen = set()
    seen_add = seen.add
    if key is None:
        for element in filterfalse(seen.__contains__, iterable):
            seen_add(element)
            yield element
    else:
        for element in iterable:
            k = key(element)
            if k not in seen:
                seen_add(k)
                yield element

def die(msg):
    "Exit the process with an error message."
    sys.exit('ERROR: ' + msg)

def parse_build_file_dependencies(path):
    "Extract the dependencies of a build.sh or *.subpackage.sh file."
    pkg_dep_prefix = 'TERMUX_PKG_DEPENDS='
    pkg_build_dep_prefix = 'TERMUX_PKG_BUILD_DEPENDS='
    subpkg_dep_prefix = 'TERMUX_SUBPKG_DEPENDS='
    dependencies = []

    with open(path, encoding="utf-8") as build_script:
        prefix = None
        for line in build_script:
            if line.startswith(pkg_dep_prefix):
                prefix = pkg_dep_prefix
            elif line.startswith(pkg_build_dep_prefix):
                prefix = pkg_build_dep_prefix
            elif line.startswith(subpkg_dep_prefix):
                prefix = subpkg_dep_prefix
            else:
                continue

            dependencies_string = line[len(prefix):]
            for char in "\"'\n":
                dependencies_string = dependencies_string.replace(char, '')

            # Split also on '|' to dependencies with '|', as in 'nodejs | nodejs-current':
            for dependency_value in re.split(',|\\|', dependencies_string):
                # Replace parenthesis to ignore version qualifiers as in "gcc (>= 5.0)":
                dependency_value = re.sub(r'\(.*?\)', '', dependency_value).strip()
                # Handle dependencies on *-dev packages:
                dependency_value = re.sub('-dev$', '', dependency_value)

                dependencies.append(dependency_value)

    return set(dependencies)

class TermuxPackage(object):
    "A main package definition represented by a directory with a build.sh file."
    def __init__(self, dir_path):
        self.dir = dir_path
        self.name = os.path.basename(self.dir)

        # search package build.sh
        build_sh_path = os.path.join(self.dir, 'build.sh')
        if not os.path.isfile(build_sh_path):
            raise Exception("build.sh not found for package '" + self.name + "'")

        self.deps = parse_build_file_dependencies(build_sh_path)
        if 'libandroid-support' not in self.deps and self.name != 'libandroid-support':
            # Every package may depend on libandroid-support without declaring it:
            self.deps.add('libandroid-support')

        # search subpackages
        self.subpkgs = []

        for filename in os.listdir(self.dir):
            if not filename.endswith('.subpackage.sh'):
                continue
            subpkg = TermuxSubPackage(self.dir + '/' + filename, self)

            self.subpkgs.append(subpkg)
            self.deps |= subpkg.deps

        # Do not depend on itself
        self.deps.discard(self.name)
        # Do not depend on any sub package
        self.deps.difference_update([subpkg.name for subpkg in self.subpkgs])

        self.needed_by = set()  # Populated outside constructor, reverse of deps.

    def __repr__(self):
        return "<{} '{}'>".format(self.__class__.__name__, self.name)

    def recursive_dependencies(self, pkgs_map):
        "All the dependencies of the package, both direct and indirect."
        result = []
        for dependency_name in sorted(self.deps):
            dependency_package = pkgs_map[dependency_name]
            result += dependency_package.recursive_dependencies(pkgs_map)
            result += [dependency_package]
        return unique_everseen(result)

class TermuxSubPackage:
    "A sub-package represented by a ${PACKAGE_NAME}.subpackage.sh file."
    def __init__(self, subpackage_file_path, parent):
        if parent is None:
            raise Exception("SubPackages should have a parent")

        self.name = os.path.basename(subpackage_file_path).split('.subpackage.sh')[0]
        self.parent = parent
        self.deps = parse_build_file_dependencies(subpackage_file_path)

    def __repr__(self):
        return "<{} '{}' parent='{}'>".format(self.__class__.__name__, self.name, self.parent)

def read_packages_from_directories(directories):
    """Construct a map from package name to TermuxPackage.
    For subpackages this maps from the subpackage name to the parent package."""
    pkgs_map = {}
    all_packages = []

    for package_dir in directories:
        for pkgdir_name in sorted(os.listdir(package_dir)):
            dir_path = package_dir + '/' + pkgdir_name
            if os.path.isfile(dir_path + '/build.sh'):
                new_package = TermuxPackage(package_dir + '/' + pkgdir_name)

                if new_package.name in pkgs_map:
                    die('Duplicated package: ' + new_package.name)
                else:
                    pkgs_map[new_package.name] = new_package
                all_packages.append(new_package)

                for subpkg in new_package.subpkgs:
                    if subpkg.name in pkgs_map:
                        die('Duplicated package: ' + subpkg.name)
                    else:
                        pkgs_map[subpkg.name] = new_package
                    all_packages.append(subpkg)

    for pkg in all_packages:
        for dependency_name in pkg.deps:
            if dependency_name not in pkgs_map:
                die('Package %s depends on non-existing package "%s"' % (pkg.name, dependency_name))
            dep_pkg = pkgs_map[dependency_name]
            if not isinstance(pkg, TermuxSubPackage):
                dep_pkg.needed_by.add(pkg)
    return pkgs_map

def generate_full_buildorder(pkgs_map):
    "Generate a build order for building all packages."
    build_order = []

    # List of all TermuxPackages without dependencies
    leaf_pkgs = [pkg for name, pkg in pkgs_map.items() if not pkg.deps]

    if not leaf_pkgs:
        die('No package without dependencies - where to start?')

    # Sort alphabetically:
    pkg_queue = sorted(leaf_pkgs, key=lambda p: p.name)

    # Topological sorting
    visited = set()

    # Tracks non-visited deps for each package
    remaining_deps = {}
    for name, pkg in pkgs_map.items():
        remaining_deps[name] = set(pkg.deps)
        for subpkg in pkg.subpkgs:
            remaining_deps[subpkg.name] = set(subpkg.deps)

    while pkg_queue:
        pkg = pkg_queue.pop(0)
        if pkg.name in visited:
            continue

        # print("Processing {}:".format(pkg.name), pkg.needed_by)
        visited.add(pkg.name)
        build_order.append(pkg)

        for other_pkg in sorted(pkg.needed_by, key=lambda p: p.name):
            # Remove this pkg from deps
            remaining_deps[other_pkg.name].discard(pkg.name)
            # ... and all its subpackages
            remaining_deps[other_pkg.name].difference_update(
                [subpkg.name for subpkg in pkg.subpkgs]
            )

            if not remaining_deps[other_pkg.name]:  # all deps were already appended?
                pkg_queue.append(other_pkg)  # should be processed

    if set(pkgs_map.values()) != set(build_order):
        print("ERROR: Cycle exists. Remaining: ")
        for name, pkg in pkgs_map.items():
            if pkg not in build_order:
                print(name, remaining_deps[name])

        sys.exit(1)

    return build_order

def generate_target_buildorder(target_path, pkgs_map):
    "Generate a build order for building the dependencies of the specified package."
    if target_path.endswith('/'):
        target_path = target_path[:-1]

    package_name = os.path.basename(target_path)
    package = pkgs_map[package_name]
    return package.recursive_dependencies(pkgs_map)

def main():
    "Generate the build order either for all packages or a specific one."
    packages_directories = ['packages']
    full_buildorder = len(sys.argv) == 1
    if not full_buildorder:
        packages_real_path = os.path.realpath('packages')
        for path in sys.argv[1:]:
            if not os.path.isdir(path):
                die('Not a directory: ' + path)
            if path.endswith('/'):
                path = path[:-1]
            parent_path = os.path.dirname(path)
            if packages_real_path != os.path.realpath(parent_path):
                packages_directories.append(parent_path)

    pkgs_map = read_packages_from_directories(packages_directories)

    if full_buildorder:
        build_order = generate_full_buildorder(pkgs_map)
    else:
        build_order = generate_target_buildorder(sys.argv[1], pkgs_map)

    for pkg in build_order:
        print(pkg.dir)

if __name__ == '__main__':
    main()
