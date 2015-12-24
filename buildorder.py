#!/usr/bin/env python3
# buildorder.py - script to generate a build order respecting package dependencies

import os
import sys


def die(msg):
    sys.exit('ERROR: ' + msg)


class TermuxBuildFile(object):
    def __init__(self, path):
        self.path = path

    def _get_dependencies(self):
        pkg_dep_prefix = 'TERMUX_PKG_DEPENDS='
        subpkg_dep_prefix = 'TERMUX_SUBPKG_DEPENDS='

        with open(self.path) as f:
            prefix = None
            for line in f:
                if line.startswith(pkg_dep_prefix):
                    prefix = pkg_dep_prefix
                elif line.startswith(subpkg_dep_prefix):
                    prefix = subpkg_dep_prefix
                else:
                    continue

                comma_deps = line[len(prefix):].replace('"', '')

                return set([
                    dep.strip() for dep in comma_deps.split(',')
                    if 'libandroid-support' not in dep
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
            raise Exception("build.sh not found")

        self.buildfile = TermuxBuildFile(build_sh_path)
        self.deps = self.buildfile._get_dependencies()

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


def buildorder():
    # List of all TermuxPackages without dependencies
    leaf_pkgs = [pkg for name, pkg in pkgs_map.items() if not pkg.deps]

    if not leaf_pkgs:
        die('No package without dependencies - where to start?')

    # Sort alphabetically, but with libandroid-support first (since dependency on libandroid-support
    # does not need to be declared explicitly, so anything might in theory depend on it to build):
    pkg_queue = sorted(leaf_pkgs, key=lambda p: '' if p.name == 'libandroid-support' else p.name)

    # Topological sorting
    build_order = []
    visited = set()

    while pkg_queue:
        pkg = pkg_queue.pop(0)
        if pkg.name in visited:
            continue
        visited.add(pkg.name)

        # print("Processing {}:".format(pkg.name), pkg.needed_by)

        build_order.append(pkg)

        for other_pkg in sorted(pkg.needed_by, key=lambda p: p.name):
            # Mark this package as done
            remaining_deps[other_pkg.name].discard(pkg.name)

            # ... and all its subpackages
            remaining_deps[other_pkg.name].difference_update(
                [subpkg.name for subpkg in pkg.subpkgs]
            )

            if not remaining_deps[other_pkg.name]:  # all deps were pruned?
                pkg_queue.append(other_pkg)

    return build_order


def generate_and_print_buildorder():
    build_order = buildorder()

    if set(pkgs_map.values()) != set(build_order):
        print("ERROR: Cycle exists. Remaining: ")
        for name, pkg in pkgs_map.items():
            if pkg not in build_order:
                print(name, remaining_deps[name])

        sys.exit(1)

    for pkg in build_order:
        print(pkg.name)

    sys.exit(0)


def print_after_deps_recursive(pkg):
    for dep in sorted(pkg.deps):
        print_after_deps_recursive(pkgs_map[dep])
    print(pkg.name)

if __name__ == '__main__':
    populate()

    if len(sys.argv) == 1:
        generate_and_print_buildorder()

    for target in sys.argv[1:]:
        print_after_deps_recursive(pkgs_map[target])
