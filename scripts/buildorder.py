#!/usr/bin/env python3
"Script to generate a build order respecting package dependencies."

import json, os, re, sys

from itertools import filterfalse

termux_arch = os.getenv('TERMUX_ARCH') or 'aarch64'
termux_global_library = os.getenv('TERMUX_GLOBAL_LIBRARY') or 'false'
termux_pkg_library = os.getenv('TERMUX_PACKAGE_LIBRARY') or 'bionic'

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

def parse_build_file_dependencies_with_vars(path, vars):
    "Extract the dependencies specified in the given variables of a build.sh or *.subpackage.sh file."
    dependencies = []

    with open(path, encoding="utf-8") as build_script:
        for line in build_script:
            if line.startswith(vars):
                dependencies_string = line.split('DEPENDS=')[1]
                for char in "\"'\n":
                    dependencies_string = dependencies_string.replace(char, '')

                # Split also on '|' to dependencies with '|', as in 'nodejs | nodejs-current':
                for dependency_value in re.split(',|\\|', dependencies_string):
                    # Replace parenthesis to ignore version qualifiers as in "gcc (>= 5.0)":
                    dependency_value = re.sub(r'\(.*?\)', '', dependency_value).strip()
                    arch = os.getenv('TERMUX_ARCH')
                    if arch is None:
                        arch = 'aarch64'
                    if arch == "x86_64":
                        arch = "x86-64"
                    dependency_value = re.sub(r'\${TERMUX_ARCH/_/-}', arch, dependency_value)

                    dependencies.append(dependency_value)

    return set(dependencies)

def parse_build_file_dependencies(path):
    "Extract the dependencies of a build.sh or *.subpackage.sh file."
    return parse_build_file_dependencies_with_vars(path, ('TERMUX_PKG_DEPENDS', 'TERMUX_PKG_BUILD_DEPENDS', 'TERMUX_SUBPKG_DEPENDS', 'TERMUX_PKG_DEVPACKAGE_DEPENDS'))

def parse_build_file_antidependencies(path):
    "Extract the antidependencies of a build.sh file."
    return parse_build_file_dependencies_with_vars(path, 'TERMUX_PKG_ANTI_BUILD_DEPENDS')

def parse_build_file_excluded_arches(path):
    "Extract the excluded arches specified in a build.sh or *.subpackage.sh file."
    arches = []

    with open(path, encoding="utf-8") as build_script:
        for line in build_script:
            if line.startswith(('TERMUX_PKG_BLACKLISTED_ARCHES', 'TERMUX_SUBPKG_EXCLUDED_ARCHES')):
                arches_string = line.split('ARCHES=')[1]
                for char in "\"'\n":
                    arches_string = arches_string.replace(char, '')
                for arches_value in re.split(',', arches_string):
                    arches.append(arches_value.strip())

    return set(arches)

def parse_build_file_variable_bool(path, var):
    value = 'false'

    with open(path, encoding="utf-8") as build_script:
        for line in build_script:
            if line.startswith(var):
                value = line.split('=')[-1].replace('\n', '')
                break

    return value == 'true'

def add_prefix_glibc_to_pkgname(name):
    return name.replace("-static", "-glibc-static") if "static" == name.split("-")[-1] else name+"-glibc"

def has_prefix_glibc(pkgname):
    pkgname = pkgname.split("-")
    return "glibc" in pkgname or "glibc32" in pkgname

class TermuxPackage(object):
    "A main package definition represented by a directory with a build.sh file."
    def __init__(self, dir_path, fast_build_mode):
        self.dir = dir_path
        self.fast_build_mode = fast_build_mode
        self.name = os.path.basename(self.dir)
        self.pkgs_cache = []
        if "gpkg" in self.dir.split("/")[-2].split("-") and not has_prefix_glibc(self.name):
            self.name = add_prefix_glibc_to_pkgname(self.name)

        # search package build.sh
        build_sh_path = os.path.join(self.dir, 'build.sh')
        if not os.path.isfile(build_sh_path):
            raise Exception("build.sh not found for package '" + self.name + "'")

        self.deps = parse_build_file_dependencies(build_sh_path)
        self.antideps = parse_build_file_antidependencies(build_sh_path)
        self.excluded_arches = parse_build_file_excluded_arches(build_sh_path)
        self.only_installing = parse_build_file_variable_bool(build_sh_path, 'TERMUX_PKG_ONLY_INSTALLING')
        self.separate_subdeps = parse_build_file_variable_bool(build_sh_path, 'TERMUX_PKG_SEPARATE_SUB_DEPENDS')
        self.accept_dep_scr = parse_build_file_variable_bool(build_sh_path, 'TERMUX_PKG_ACCEPT_PKG_IN_DEP')

        if os.getenv('TERMUX_ON_DEVICE_BUILD') == "true" and termux_pkg_library == "bionic":
            always_deps = ['libc++']
            for dependency_name in always_deps:
                if dependency_name not in self.deps and self.name not in always_deps:
                    self.deps.add(dependency_name)

        # search subpackages
        self.subpkgs = []

        for filename in os.listdir(self.dir):
            if not filename.endswith('.subpackage.sh'):
                continue
            subpkg = TermuxSubPackage(self.dir + '/' + filename, self)
            if termux_arch in subpkg.excluded_arches:
                continue

            self.subpkgs.append(subpkg)

        subpkg = TermuxSubPackage(self.dir + '/' + self.name + '-static' + '.subpackage.sh', self, virtual=True)
        self.subpkgs.append(subpkg)

        self.needed_by = set()  # Populated outside constructor, reverse of deps.

    def __repr__(self):
        return "<{} '{}'>".format(self.__class__.__name__, self.name)

    def recursive_dependencies(self, pkgs_map, dir_root=None):
        "All the dependencies of the package, both direct and indirect."
        result = []
        is_root = dir_root == None
        if is_root:
            dir_root = self.dir
        if is_root or not self.fast_build_mode or not self.separate_subdeps:
            for subpkg in self.subpkgs:
                if f"{self.name}-static" != subpkg.name:
                    self.deps.add(subpkg.name)
                    self.deps |= subpkg.deps
            self.deps -= self.antideps
            self.deps.discard(self.name)
            if not self.fast_build_mode or self.dir == dir_root:
                self.deps.difference_update([subpkg.name for subpkg in self.subpkgs])
        for dependency_name in sorted(self.deps):
            if termux_global_library == "true" and termux_pkg_library == "glibc" and not has_prefix_glibc(dependency_name):
                mod_dependency_name = add_prefix_glibc_to_pkgname(dependency_name)
                dependency_name = mod_dependency_name if mod_dependency_name in pkgs_map else dependency_name
            if dependency_name not in self.pkgs_cache:
                self.pkgs_cache.append(dependency_name)
                dependency_package = pkgs_map[dependency_name]
                if dependency_package.dir != dir_root and dependency_package.only_installing and not self.fast_build_mode:
                    continue
                result += dependency_package.recursive_dependencies(pkgs_map, dir_root)
                if dependency_package.accept_dep_scr or dependency_package.dir != dir_root:
                    result += [dependency_package]
        return unique_everseen(result)

class TermuxSubPackage:
    "A sub-package represented by a ${PACKAGE_NAME}.subpackage.sh file."
    def __init__(self, subpackage_file_path, parent, virtual=False):
        if parent is None:
            raise Exception("SubPackages should have a parent")

        self.name = os.path.basename(subpackage_file_path).split('.subpackage.sh')[0]
        if "gpkg" in subpackage_file_path.split("/")[-3].split("-") and not has_prefix_glibc(self.name):
            self.name = add_prefix_glibc_to_pkgname(self.name)
        self.parent = parent
        self.deps = set([parent.name])
        self.only_installing = parent.only_installing
        self.accept_dep_scr = parent.accept_dep_scr
        self.excluded_arches = set()
        if not virtual:
            self.deps |= parse_build_file_dependencies(subpackage_file_path)
            self.excluded_arches |= parse_build_file_excluded_arches(subpackage_file_path)
        self.dir = parent.dir

        self.needed_by = set()  # Populated outside constructor, reverse of deps.

    def __repr__(self):
        return "<{} '{}' parent='{}'>".format(self.__class__.__name__, self.name, self.parent)

    def recursive_dependencies(self, pkgs_map, dir_root=None):
        """All the dependencies of the subpackage, both direct and indirect.
        Only relevant when building in fast-build mode"""
        result = []
        if dir_root == None:
            dir_root = self.dir
        for dependency_name in sorted(self.deps):
            if dependency_name == self.parent.name:
                self.parent.deps.discard(self.name)
            dependency_package = pkgs_map[dependency_name]
            if dependency_package not in self.parent.subpkgs:
                result += dependency_package.recursive_dependencies(pkgs_map, dir_root=dir_root)
            if dependency_package.accept_dep_scr or dependency_package.dir != dir_root:
                result += [dependency_package]
        return unique_everseen(result)

def read_packages_from_directories(directories, fast_build_mode, full_buildmode):
    """Construct a map from package name to TermuxPackage.
    Subpackages are mapped to the parent package if fast_build_mode is false."""
    pkgs_map = {}
    all_packages = []

    if full_buildmode:
        # Ignore directories and get all folders from repo.json file
        with open ('repo.json') as f:
            data = json.load(f)
        directories = []
        for d in data.keys():
            if d != "pkg_format":
                directories.append(d)

    for package_dir in directories:
        for pkgdir_name in sorted(os.listdir(package_dir)):
            dir_path = package_dir + '/' + pkgdir_name
            if os.path.isfile(dir_path + '/build.sh'):
                new_package = TermuxPackage(package_dir + '/' + pkgdir_name, fast_build_mode)

                if termux_arch in new_package.excluded_arches:
                    continue

                if new_package.name in pkgs_map:
                    die('Duplicated package: ' + new_package.name)
                else:
                    pkgs_map[new_package.name] = new_package
                all_packages.append(new_package)

                for subpkg in new_package.subpkgs:
                    if termux_arch in subpkg.excluded_arches:
                        continue
                    if subpkg.name in pkgs_map:
                        die('Duplicated package: ' + subpkg.name)
                    elif fast_build_mode:
                        pkgs_map[subpkg.name] = subpkg
                    else:
                        pkgs_map[subpkg.name] = new_package
                    all_packages.append(subpkg)

    for pkg in all_packages:
        for dependency_name in pkg.deps:
            if dependency_name not in pkgs_map:
                die('Package %s depends on non-existing package "%s"' % (pkg.name, dependency_name))
            dep_pkg = pkgs_map[dependency_name]
            if fast_build_mode or not isinstance(pkg, TermuxSubPackage):
                dep_pkg.needed_by.add(pkg)
    return pkgs_map

def generate_full_buildorder(pkgs_map):
    "Generate a build order for building all packages."
    build_order = []

    # List of all TermuxPackages without dependencies
    leaf_pkgs = [pkg for pkg in pkgs_map.values() if not pkg.deps]

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
        print("ERROR: Cycle exists. Remaining: ", file=sys.stderr)
        for name, pkg in pkgs_map.items():
            if pkg not in build_order:
                print(name, remaining_deps[name], file=sys.stderr)

        # Print cycles so we have some idea where to start fixing this.
        def find_cycles(deps, pkg, path):
            """Yield every dependency path containing a cycle."""
            if pkg in path:
                yield path + [pkg]
            else:
                for dep in deps[pkg]:
                    yield from find_cycles(deps, dep, path + [pkg])

        cycles = set()
        for pkg in remaining_deps:
            for path_with_cycle in find_cycles(remaining_deps, pkg, []):
                # Cut the path down to just the cycle.
                cycle_start = path_with_cycle.index(path_with_cycle[-1])
                cycles.add(tuple(path_with_cycle[cycle_start:]))
        for cycle in sorted(cycles):
            print(f"cycle: {' -> '.join(cycle)}", file=sys.stderr)

        sys.exit(1)

    return build_order

def generate_target_buildorder(target_path, pkgs_map, fast_build_mode):
    "Generate a build order for building the dependencies of the specified package."
    if target_path.endswith('/'):
        target_path = target_path[:-1]

    package_name = os.path.basename(target_path)
    if "gpkg" in target_path.split("/")[-2].split("-") and not has_prefix_glibc(package_name):
        package_name += "-glibc"
    package = pkgs_map[package_name]
    # Do not depend on any sub package
    if fast_build_mode:
        package.deps.difference_update([subpkg.name for subpkg in package.subpkgs])
    return package.recursive_dependencies(pkgs_map)

def main():
    "Generate the build order either for all packages or a specific one."
    import argparse

    parser = argparse.ArgumentParser(description='Generate order in which to build dependencies for a package. Generates')
    parser.add_argument('-i', default=False, action='store_true',
                        help='Generate dependency list for fast-build mode. This includes subpackages in output since these can be downloaded.')
    parser.add_argument('package', nargs='?',
                        help='Package to generate dependency list for.')
    parser.add_argument('package_dirs', nargs='*',
                        help='Directories with packages. Can for example point to "../community-packages/packages". Note that the packages suffix is no longer added automatically if not present.')
    args = parser.parse_args()
    fast_build_mode = args.i
    package = args.package
    packages_directories = args.package_dirs

    if not package:
        full_buildorder = True
    else:
        full_buildorder = False

    if fast_build_mode and full_buildorder:
        die('-i mode does not work when building all packages')

    if not full_buildorder:
        for path in packages_directories:
            if not os.path.isdir(path):
                die('Not a directory: ' + path)

    if package:
        if package[-1] == "/":
            package = package[:-1]
        if not os.path.isdir(package):
            die('Not a directory: ' + package)
        if not os.path.relpath(os.path.dirname(package), '.') in packages_directories:
            packages_directories.insert(0, os.path.dirname(package))
    pkgs_map = read_packages_from_directories(packages_directories, fast_build_mode, full_buildorder)

    if full_buildorder:
        build_order = generate_full_buildorder(pkgs_map)
    else:
        build_order = generate_target_buildorder(package, pkgs_map, fast_build_mode)

    for pkg in build_order:
        pkg_name = pkg.name
        if termux_global_library == "true" and termux_pkg_library == "glibc" and not has_prefix_glibc(pkg_name):
            pkg_name = add_prefix_glibc_to_pkgname(pkg_name)
        print("%-30s %s" % (pkg_name, pkg.dir))

if __name__ == '__main__':
    main()
