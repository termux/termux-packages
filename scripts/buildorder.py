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

def remove_char(var):
    for char in "\"'\n":
        var = var.replace(char, '')
    return var

def parse_build_file_dependencies_with_vars(path, vars):
    "Extract the dependencies specified in the given variables of a build.sh or *.subpackage.sh file."
    dependencies = []

    with open(path, encoding="utf-8") as build_script:
        for line in build_script:
            if line.startswith(vars):
                dependencies_string = remove_char(line.split('DEPENDS=')[1])

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
                arches_string = remove_char(line.split('ARCHES=')[1])
                for arches_value in re.split(',', arches_string):
                    arches.append(arches_value.strip())

    return set(arches)

def parse_build_file_variable(path, var):
    value = None

    with open(path, encoding="utf-8") as build_script:
        for line in build_script:
            if line.startswith(var):
                value = remove_char(line.split('=')[-1])
                break

    return value

def parse_build_file_variable_bool(path, var, with_none=False):
    value = parse_build_file_variable(path, var)
    return None if with_none and not value else value == 'true'

def add_prefix_glibc_to_pkgname(name):
    return name.replace("-static", "-glibc-static") if "static" == name.split("-")[-1] else name + "-glibc"

def has_prefix_glibc(pkgname):
    return "glibc" in pkgname.split("-")

def get_source_sh(pkgpath):
    pkgname = os.path.basename(pkgpath)
    pkgpath = os.path.join(pkgpath, 'build.sh')
    if not os.path.isfile(pkgpath):
        die("build.sh not found for package '" + pkgname + "'")
    return pkgpath

def directories_repo_json():
    with open ('repo.json') as f:
        data = json.load(f)
    directories = []
    for d in data.keys():
        if d != "pkg_format":
            directories.append(d)
    return directories

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
        build_sh_path = get_source_sh(self.dir)

        self.virtual = parse_build_file_variable_bool(build_sh_path, 'TERMUX_VIRTUAL_PKG')
        self.virtual_src = parse_build_file_variable(build_sh_path, 'TERMUX_VIRTUAL_PKG_SRC')
        if self.virtual_src:
            if "/" not in self.virtual_src:
                for dir in directories_repo_json():
                    pkgpath = os.path.join(dir, self.virtual_src)
                    if os.path.isdir(pkgpath):
                        self.virtual_src = pkgpath
                        break
                else:
                    die(f"source package '{self.virtual_src}' not found for virtual package '{self.name}'")
            self.virtual_src = get_source_sh(self.virtual_src)
            self.virtual = True
        if self.virtual:
            self.name += "-virtual"

        self.deps = parse_build_file_dependencies(build_sh_path)
        self.pkg_deps = parse_build_file_dependencies_with_vars(build_sh_path, 'TERMUX_PKG_DEPENDS')
        self.antideps = parse_build_file_antidependencies(build_sh_path)
        self.excluded_arches = parse_build_file_excluded_arches(build_sh_path)
        self.only_installing = parse_build_file_variable_bool(build_sh_path, 'TERMUX_PKG_ONLY_INSTALLING', self.virtual)
        self.separate_subdeps = parse_build_file_variable_bool(build_sh_path, 'TERMUX_PKG_SEPARATE_SUB_DEPENDS', self.virtual)
        self.accept_dep_scr = parse_build_file_variable_bool(build_sh_path, 'TERMUX_PKG_ACCEPT_PKG_IN_DEP', self.virtual)

        if self.virtual_src:
            if not self.deps:
                self.deps = parse_build_file_dependencies(self.virtual_src)
            if not self.pkg_deps:
                self.pkg_deps = parse_build_file_dependencies_with_vars(self.virtual_src, 'TERMUX_PKG_DEPENDS')
            if not self.antideps:
                self.antideps = parse_build_file_antidependencies(self.virtual_src)
            if not self.excluded_arches:
                self.excluded_arches = parse_build_file_excluded_arches(self.virtual_src)
            if not self.only_installing:
                self.only_installing = parse_build_file_variable_bool(self.virtual_src, 'TERMUX_PKG_ONLY_INSTALLING')
            if not self.separate_subdeps:
                self.separate_subdeps = parse_build_file_variable_bool(self.virtual_src, 'TERMUX_PKG_SEPARATE_SUB_DEPENDS')
            if not self.accept_dep_scr:
                self.accept_dep_scr = parse_build_file_variable_bool(self.virtual_src, 'TERMUX_PKG_ACCEPT_PKG_IN_DEP')
        for pkg_var in "deps", "pkg_deps", "antideps", "excluded_arches":
            if getattr(self, pkg_var) == {''}:
                setattr(self, pkg_var, set())

        if os.getenv('TERMUX_ON_DEVICE_BUILD') == "true" and termux_pkg_library == "bionic":
            always_deps = ['libc++']
            for dependency_name in always_deps:
                if dependency_name not in self.deps and self.name not in always_deps:
                    self.deps.add(dependency_name)

        # search subpackages
        self.subpkgs = []

        if not self.virtual:
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

    def recursive_dependencies(self, pkgs_map, dir_root=None, only_installing=False):
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
        for dependency_name in sorted(self.pkg_deps if only_installing else self.deps):
            if termux_global_library == "true" and termux_pkg_library == "glibc" and not has_prefix_glibc(dependency_name):
                mod_dependency_name = add_prefix_glibc_to_pkgname(dependency_name)
                dependency_name = mod_dependency_name if mod_dependency_name in pkgs_map else dependency_name
            if dependency_name not in self.pkgs_cache:
                self.pkgs_cache.append(dependency_name)
                dependency_package = pkgs_map[dependency_name]
                dep_only_installing = (dependency_package.dir != dir_root and dependency_package.only_installing and not self.fast_build_mode)
                if dep_only_installing or self.fast_build_mode:
                    result += dependency_package.recursive_dependencies(pkgs_map, dir_root, dep_only_installing)
                if not dep_only_installing and (dependency_package.accept_dep_scr or dependency_package.dir != dir_root):
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
        self.fast_build_mode = parent.fast_build_mode
        self.accept_dep_scr = parent.accept_dep_scr
        self.depend_on_parent = None
        self.only_installing = None
        self.excluded_arches = set()
        self.deps = set()
        if not virtual:
            self.deps |= parse_build_file_dependencies(subpackage_file_path)
            self.pkg_deps = parse_build_file_dependencies_with_vars(subpackage_file_path, 'TERMUX_SUBPKG_DEPENDS')
            self.excluded_arches |= parse_build_file_excluded_arches(subpackage_file_path)
            self.depend_on_parent = parse_build_file_variable(subpackage_file_path, "TERMUX_SUBPKG_DEPEND_ON_PARENT")
            self.only_installing = parse_build_file_variable(subpackage_file_path, "TERMUX_SUBPKG_ONLY_INSTALLING")
        if not self.depend_on_parent or self.depend_on_parent == "unversioned" or self.depend_on_parent == "true":
            self.deps |= set([parent.name])
        elif self.depend_on_parent == "deps":
            self.deps |= parent.deps
        self.only_installing = self.only_installing == "true" if self.only_installing else parent.only_installing
        self.dir = parent.dir

        self.needed_by = set()  # Populated outside constructor, reverse of deps.

    def __repr__(self):
        return "<{} '{}' parent='{}'>".format(self.__class__.__name__, self.name, self.parent)

    def recursive_dependencies(self, pkgs_map, dir_root=None, only_installing=False):
        """All the dependencies of the subpackage, both direct and indirect.
        Only relevant when building in fast-build mode"""
        result = []
        if dir_root:
            dir_root = self.dir
        for dependency_name in sorted(self.pkg_deps if only_installing else self.deps):
            if dependency_name == self.parent.name:
                self.parent.deps.discard(self.name)
            dependency_package = pkgs_map[dependency_name]
            dep_only_installing = (dependency_package.dir != dir_root and dependency_package.only_installing and not self.fast_build_mode)
            if dependency_package not in self.parent.subpkgs and (dep_only_installing or self.fast_build_mode):
                result += dependency_package.recursive_dependencies(pkgs_map, dir_root, dep_only_installing)
            if not dep_only_installing and (dependency_package.accept_dep_scr or dependency_package.dir != dir_root):
                result += [dependency_package]
        return unique_everseen(result)

def read_packages_from_directories(directories, fast_build_mode, full_buildmode):
    """Construct a map from package name to TermuxPackage.
    Subpackages are mapped to the parent package if fast_build_mode is false."""
    pkgs_map = {}
    all_packages = []

    if full_buildmode:
        # Ignore directories and get all folders from repo.json file
        directories = directories_repo_json()

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
                    pkgs_map[new_package.dir if new_package.virtual else new_package.name] = new_package
                all_packages.append(new_package)

                for subpkg in new_package.subpkgs:
                    if termux_arch in subpkg.excluded_arches:
                        continue
                    if subpkg.name in pkgs_map:
                        die('Duplicated package: ' + subpkg.name)
                    pkgs_map[subpkg.name] = subpkg
                    all_packages.append(subpkg)

    for pkg in all_packages:
        for dependency_name in pkg.deps:
            if dependency_name not in pkgs_map:
                die('Package %s depends on non-existing package "%s"' % (pkg.name, dependency_name))
            dep_pkg = pkgs_map[dependency_name]
            if fast_build_mode or not isinstance(pkg, TermuxSubPackage):
                dep_pkg.needed_by.add(pkg)
    return pkgs_map

def remove_only_installing_deps(pkgs_map, deps):
    """Complete replacement of packages that have the `TERMUX_{SUB}PKG_ONLY_INSTALLING` (`only_installing` value)
    variable set to `true` with their dependencies from the `pkg_deps` value."""

    # list of packages that have been removed from the dependency list,
    # it is necessary that these packages cannot appear in the dependency list again
    pkgs_only_installing = set()

    while True:
        bools_only_installing = [pkgs_map[dep].only_installing for dep in deps]
        if True in bools_only_installing:
            dep = list(deps)[bools_only_installing.index(True)]
            pkgs_only_installing |= {dep}
            deps |= pkgs_map[dep].pkg_deps
            deps -= pkgs_only_installing
        else:
            break

    return deps

def generate_full_buildorder(pkgs_map, build_mode=True, without_cyclic_dependencies=False):
    "Generate a build order for building all packages."

    # list that will store the names of packages (with the names of their subpackages) sorted by dependencies
    pkgs_sort = []

    # dictionary that will store packages and their unfound dependencies in order to find cyclic dependencies
    requireds = {}

    # copy of the pkgs_map list without subpackages which will contain only unsorted packages
    pkgs_map_copy = {pkg.name:pkg for pkg in pkgs_map.values() if not build_mode or isinstance(pkg, TermuxPackage)}

    # Start sorting packages by dependencies.
    while len(pkgs_sort) < len(pkgs_map):
        # This loop is necessary to repeat the check of package dependencies
        # with each new content of the `pkgs_sort` list. An infinite loop will
        # not occur since the checking algorithm will update the `pkgs_sort`
        # list and there are additional protections in `buildorder.py` that
        # prevent package dependencies from being configured incorrectly.
        initial_len_sort = len(pkgs_sort)
        for pkg in pkgs_map_copy.copy().values():
            subpkgs = [subpkg.name for subpkg in pkg.subpkgs] if build_mode else []
            # Getting the complete list of package dependencies
            deps = pkg.deps.copy()
            if build_mode:
                for subpkg in subpkgs:
                    deps |= pkgs_map[subpkg].deps
                deps = remove_only_installing_deps(pkgs_map, deps - {pkg.name} - set(subpkgs))
            # Checking package dependencies
            for dep in deps:
                if dep not in pkgs_sort:
                    # Saving the requested dependency to determine whether the package
                    # is in a circular dependency. If a package has a circular dependency,
                    # the requested dependency that causes the cycle will be ignored.
                    if build_mode and isinstance(pkgs_map[dep], TermuxSubPackage):
                        dep = pkgs_map[dep].parent.name
                    requireds[pkg.name] = dep
                    required = requireds[pkg.name]
                    while not without_cyclic_dependencies and required in requireds.keys():
                        # Checking for cyclic dependencies of a package.
                        required = requireds[required]
                        if required == pkg.name:
                            break
                    else:
                        break
            else:
                yield pkg
                pkgs_sort.append(pkg.name)
                pkgs_sort += subpkgs
                if pkg.name in requireds.keys():
                    del requireds[pkg.name]
                del pkgs_map_copy[pkg.name]
        if without_cyclic_dependencies and len(pkgs_sort) == initial_len_sort:
            break

def generate_target_buildorder(target_path, pkgs_map, fast_build_mode):
    "Generate a build order for building the dependencies of the specified package."
    if target_path.endswith('/'):
        target_path = target_path[:-1]

    if target_path in pkgs_map.keys():
        package = pkgs_map[target_path]
    else:
        package_name = os.path.basename(target_path)
        if "gpkg" in target_path.split("/")[-2].split("-") and not has_prefix_glibc(package_name):
            package_name = add_prefix_glibc_to_pkgname(package_name)
        package = pkgs_map[package_name]
    # Do not depend on any sub package
    if not package.virtual and fast_build_mode:
        package.deps.difference_update([subpkg.name for subpkg in package.subpkgs])
    return package.recursive_dependencies(pkgs_map)

def get_list_cyclic_dependencies(pkgs_map, index=[], ok_pkgs=set(), pkgname=None, build_mode=False):
    "Find and return circular dependencies for all packages or for one specified package."

    if len(index) == 0:
        ok_pkgs = {pkg.name for pkg in generate_full_buildorder(pkgs_map, build_mode, True)}
        range_pkgs = ({pkgname} if pkgname else {pkg for pkg in pkgs_map.keys() if not build_mode or isinstance(pkgs_map[pkg], TermuxPackage)}) - ok_pkgs
    else:
        range_pkgs = pkgs_map[index[-1]].deps.copy()
        if build_mode:
            for subpkg in pkgs_map[index[-1]].subpkgs:
                range_pkgs |= subpkg.deps
            range_pkgs = remove_only_installing_deps(pkgs_map, range_pkgs - {index[-1]} - {subpkg.name for subpkg in pkgs_map[index[-1]].subpkgs})
        range_pkgs -= ok_pkgs

    for pkg in range_pkgs:
        if build_mode and isinstance(pkgs_map[pkg], TermuxSubPackage):
            pkg = pkgs_map[pkg].parent.name
        if pkg in index:
            yield " -> ".join((index.copy() if pkgname else index[index.index(pkg)::]) + [pkg])
        else:
            yield from get_list_cyclic_dependencies(pkgs_map, index + [pkg], ok_pkgs, pkgname, build_mode)

def main():
    "Generate the build order either for all packages or a specific one."
    import argparse

    parser = argparse.ArgumentParser(description='Generate order in which to build dependencies for a package. Generates')
    parser.add_argument('-i', default=False, action='store_true',
                        help='Generate dependency list for fast-build mode. This includes subpackages in output since these can be downloaded.')
    parser.add_argument('-l', default=False, action='store_true',
			help='Return a list of packages that have a circular dependency. To check dependencies with subpackages, add the `-i` flag.')
    parser.add_argument('package', nargs='?',
                        help='Package to generate dependency list for.')
    parser.add_argument('package_dirs', nargs='*',
                        help='Directories with packages. Can for example point to "../community-packages/packages". Note that the packages suffix is no longer added automatically if not present.')
    args = parser.parse_args()
    fast_build_mode = args.i
    get_list_cirdep = args.l
    package = args.package
    packages_directories = args.package_dirs

    if not package:
        full_buildorder = True
    else:
        full_buildorder = False

    if fast_build_mode and full_buildorder and not get_list_cirdep:
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

    if get_list_cirdep:
        pkgname = None
        if not full_buildorder:
            pkgname = package.split("/")[-1]
            if "gpkg" in package.split("/")[-2].split("-") and not has_prefix_glibc(pkgname):
                pkgname = add_prefix_glibc_to_pkgname(pkgname)
        cycles = set()
        for cycle in get_list_cyclic_dependencies(pkgs_map, pkgname=pkgname, build_mode=not(fast_build_mode)):
            if cycle not in cycles:
                print("-", cycle)
            cycles |= {cycle}
        print(f"Found {len(cycles)} cyclic dependencies")
        sys.exit(0)

    if full_buildorder:
        build_order = generate_full_buildorder(pkgs_map)
    else:
        build_order = generate_target_buildorder(package, pkgs_map, fast_build_mode)

    for pkg in build_order:
        pkgname = pkg.name
        if termux_global_library == "true" and termux_pkg_library == "glibc" and not has_prefix_glibc(pkgname):
            pkgname = add_prefix_glibc_to_pkgname(pkgname)
        print("%-30s %s" % (pkgname, pkg.dir))

if __name__ == '__main__':
    main()
