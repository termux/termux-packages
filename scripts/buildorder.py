#!/usr/bin/env python3
# buildorder.py - script to generate a build order respecting package dependencies

import os
import re
import sys

from itertools import filterfalse


# https://docs.python.org/3/library/itertools.html#itertools-recipes

def unique_everseen(iterable, key=None):
    "List unique elements, preserving order. Remember all elements ever seen."
    # unique_everseen('AAAABBBCCDAABBB') --> A B C D
    # unique_everseen('ABBCcAD', str.lower) --> A B C D
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
    sys.exit('ERROR: ' + msg)


class TermuxBuildFile(object):
    def __init__(self, path):
        self.path = path

    def _get_dependencies(self):
        pkg_dep_prefix = 'TERMUX_PKG_DEPENDS='
        subpkg_dep_prefix = 'TERMUX_SUBPKG_DEPENDS='

        with open(self.path, encoding="utf-8") as f:
            prefix = None
            for line in f:
                if line.startswith(pkg_dep_prefix):
                    prefix = pkg_dep_prefix
                elif line.startswith(subpkg_dep_prefix):
                    prefix = subpkg_dep_prefix
                else:
                    continue

                comma_deps = line[len(prefix):].replace('"', '').replace("'", '')

                return set([
                    # Replace parenthesis to handle version qualifiers, as in "gcc (>= 5.0)":
                    re.sub(r'\(.*?\)', '', dep).replace('-dev', '').strip() for dep in comma_deps.split(',')
                ])

        # no deps found
        return set()


class TermuxPackage(object):
    PACKAGES_DIR = 'packages'

    def __init__(self, name):
        self.name = name
        self.dir = os.path.join(self.PACKAGES_DIR, name)

        # search package build.sh
        build_sh_path = os.path.join(self.dir, 'build.sh')
        if not os.path.isfile(build_sh_path):
            raise Exception("build.sh not found for package '" + name + "'")

        self.buildfile = TermuxBuildFile(build_sh_path)
        self.deps = self.buildfile._get_dependencies()
        if 'libandroid-support' not in self.deps and self.name != 'libandroid-support':
            # Every package may depend on libandroid-support without declaring it:
            self.deps.add('libandroid-support')

        # search subpackages
        self.subpkgs = []

        for filename in os.listdir(self.dir):
            if not filename.endswith('.subpackage.sh'):
                continue

            subpkg_name = filename.split('.subpackage.sh')[0]
            subpkg = TermuxSubPackage(subpkg_name, parent=self)

            self.subpkgs.append(subpkg)
            self.deps |= subpkg.deps

        # Do not depend on itself
        self.deps.discard(self.name)
        # Do not depend on any sub package
        self.deps.difference_update([subpkg.name for subpkg in self.subpkgs])

        self.needed_by = set()  # to be completed outside, reverse of    deps

    def __repr__(self):
        return "<{} '{}'>".format(self.__class__.__name__, self.name)


class TermuxSubPackage(TermuxPackage):

    def __init__(self, name, parent=None):
        if parent is None:
            raise Exception("SubPackages should have a parent")

        self.name = name
        self.parent = parent
        self.buildfile = TermuxBuildFile(os.path.join(self.parent.dir, name + '.subpackage.sh'))
        self.deps = self.buildfile._get_dependencies()

    def __repr__(self):
        return "<{} '{}' parent='{}'>".format(self.__class__.__name__, self.name, self.parent)


# Tracks non-visited deps for each package
remaining_deps = {}

# Mapping from package name to TermuxPackage
# (if subpackage, mapping from subpackage name to parent package)
pkgs_map = {}

# Reverse dependencies
pkg_depends_on = {}

PACKAGES_DIR = 'packages'


def populate():

    for pkgdir_name in sorted(os.listdir(PACKAGES_DIR)):

        pkg = TermuxPackage(pkgdir_name)

        pkgs_map[pkg.name] = pkg

        for subpkg in pkg.subpkgs:
            pkgs_map[subpkg.name] = pkg
            remaining_deps[subpkg.name] = set(subpkg.deps)

        remaining_deps[pkg.name] = set(pkg.deps)

    all_pkg_names = set(pkgs_map.keys())

    for name, pkg in pkgs_map.items():
        for dep_name in remaining_deps[name]:
            if dep_name not in all_pkg_names:
                die('Package %s depends on non-existing package "%s"' % (
                 name, dep_name
                ))

            dep_pkg = pkgs_map[dep_name]
            dep_pkg.needed_by.add(pkg)


def generate_full_buildorder():
    build_order = []

    # List of all TermuxPackages without dependencies
    leaf_pkgs = [pkg for name, pkg in pkgs_map.items() if not pkg.deps]

    if not leaf_pkgs:
        die('No package without dependencies - where to start?')

    # Sort alphabetically:
    pkg_queue = sorted(leaf_pkgs, key=lambda p: p.name)

    # Topological sorting
    visited = set()

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


def deps_then_me(pkg):
    l = []

    for dep in sorted(pkg.deps):
        l += deps_then_me(pkgs_map[dep])
    l += [pkg]

    return l


def generate_targets_buildorder(targetnames):
    buildorder = []

    for pkgname in targetnames:
        if not pkgname in pkgs_map:
            die('Dependencies for ' + pkgname + ' could not be calculated (skip dependency check with -s)')
        buildorder += deps_then_me(pkgs_map[pkgname])

    return unique_everseen(buildorder)

if __name__ == '__main__':
    populate()

    if len(sys.argv) == 1:
        bo = generate_full_buildorder()
    else:
        bo = generate_targets_buildorder(sys.argv[1:])

    for pkg in bo:
        print(pkg.name)
