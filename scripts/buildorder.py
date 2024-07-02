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

def parse_build_file_variable(path, var):
    value = None

    with open(path, encoding="utf-8") as build_script:
        for line in build_script:
            if line.startswith(var):
                value = line.split('=')[-1].replace('\n', '')
                break

    return value

def parse_build_file_variable_bool(path, var):
    return parse_build_file_variable(path, var) == 'true'

def add_prefix_glibc_to_pkgname(name):
	return name.replace("-static", "-glibc-static") if "static" == name.split("-")[-1] else name+"-glibc"

class TermuxPackage(object):
    "A main package definition represented by a directory with a build.sh file."
    def __init__(self, dir_path, fast_build_mode):
        self.dir = dir_path
        self.fast_build_mode = fast_build_mode
        self.name = os.path.basename(self.dir)
        self.pkgs_cache = []
        if "gpkg" in self.dir.split("/")[-2].split("-") and "glibc" not in self.name.split("-"):
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
            if termux_global_library == "true" and termux_pkg_library == "glibc" and "glibc" not in dependency_name.split("-"):
                mod_dependency_name = add_prefix_glibc_to_pkgname(dependency_name)
                dependency_name = mod_dependency_name if mod_dependency_name in pkgs_map else dependency_name
            if dependency_name not in self.pkgs_cache:
                self.pkgs_cache.append(dependency_name)
                dependency_package = pkgs_map[dependency_name]
                if dependency_package.dir != dir_root and dependency_package.only_installing and not self.fast_build_mode:
                    continue
                if self.fast_build_mode:
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
        if "gpkg" in subpackage_file_path.split("/")[-3].split("-") and "glibc" not in self.name.split("-"):
            self.name = add_prefix_glibc_to_pkgname(self.name)
        self.parent = parent
        self.virtual = virtual
        self.only_installing = parent.only_installing
        self.accept_dep_scr = parent.accept_dep_scr
        self.depend_on_parent = None
        self.excluded_arches = set()
        self.deps = set()
        if not virtual:
            self.deps |= parse_build_file_dependencies(subpackage_file_path)
            self.excluded_arches |= parse_build_file_excluded_arches(subpackage_file_path)
            self.depend_on_parent = parse_build_file_variable(subpackage_file_path, "TERMUX_SUBPKG_DEPEND_ON_PARENT")
        if not self.depend_on_parent or self.depend_on_parent == "unversioned" or self.depend_on_parent == "true":
            self.deps |= set([parent.name])
        elif self.depend_on_parent == "deps":
            self.deps |= parent.deps
        self.dir = parent.dir

        self.needed_by = set()  # Populated outside constructor, reverse of deps.

    def __repr__(self):
        return "<{} '{}' parent='{}'>".format(self.__class__.__name__, self.name, self.parent)

    def recursive_dependencies(self, pkgs_map, dir_root=None):
        """All the dependencies of the subpackage, both direct and indirect.
        Only relevant when building in fast-build mode"""
        result = []
        if not dir_root:
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

def generate_full_buildorder(pkgs_map):
    "Generate a build order for building all packages."
    # Identify packages that have no dependencies and are not subpackages.
    pkgs_sort = [pkg.name for pkg in pkgs_map.values() if not pkg.deps and isinstance(pkg, TermuxPackage)]

    if not pkgs_sort:
        die('No package without dependencies - where to start?')

    # Create a list `build_order` with packages from the list `pkgs_sort`.
    build_order = [pkgs_map[pkg] for pkg in pkgs_sort]

    # Get a list of cyclic dependencies for proper operation of package sorting.
    cyclic_deps_list = get_list_cyclic_dependencies(pkgs_map, return_list=True, build_mode=True)

    # Start sorting packages by dependencies.
    while len(pkgs_sort) < len(pkgs_map):
        # This loop is necessary to repeat the check of package dependencies
        # with each new content of the `pkgs_sort` list. An infinite loop will
        # not occur since the checking algorithm will update the `pkgs_sort`
        # list and there are additional protections in `buildorder.py` that
        # prevent package dependencies from being configured incorrectly.
        for pkg in pkgs_map.values():
            if pkg.name in pkgs_sort:
                continue
            is_subpackage = isinstance(pkg, TermuxSubPackage)
            if is_subpackage and pkg.parent.name not in pkgs_sort:
                # Since these packages will be compiled, the sorting should
                # start with the package and then with its subpackages.
                pkg = pkg.parent
                is_subpackage = False
            subpkgs = [subpkg.name for subpkg in (pkg.parent.subpkgs if is_subpackage else pkg.subpkgs)]
            deps = pkg.deps
            for subpkg in subpkgs:
                if not pkgs_map[subpkg].virtual:
                    deps |= pkgs_map[subpkg].deps
            if pkg.name in deps:
                deps.remove(pkg.name)
            for subpkg in subpkgs:
                if subpkg in deps:
                    deps.remove(subpkg)
            for dep in deps:
                # First, package dependencies are checked for circular dependencies.
                # If a package does not have a cyclic dependency, then the condition
                # is triggered that the dependency is not in the `subpkgs` list and
                # in the `pkgs_sort` list. If the condition returns `True`, then the
                # package is added to the `build_order` list (except for subpackages)
                # and to the `pkgs_sort` list.
                for cyclic in cyclic_deps_list:
                    if pkg.name in cyclic and dep == cyclic[cyclic.index(pkg.name)+1]:
                        break
                else:
                    if dep not in subpkgs and dep not in pkgs_sort:
                        if pkg.name == "zstd-glibc":
                            print(pkg.name, dep, pkg.deps)
                        break
            else:
                print(len(pkgs_sort), len(pkgs_map))
                if not is_subpackage:
                    build_order.append(pkg)
                pkgs_sort.append(pkg.name)
                pkgs_sort += subpkgs

    return build_order

def generate_target_buildorder(target_path, pkgs_map, fast_build_mode):
    "Generate a build order for building the dependencies of the specified package."
    if target_path.endswith('/'):
        target_path = target_path[:-1]

    package_name = os.path.basename(target_path)
    if "gpkg" in target_path.split("/")[-2].split("-") and "glibc" not in package_name.split("-"):
        package_name += "-glibc"
    package = pkgs_map[package_name]
    # Do not depend on any sub package
    if fast_build_mode:
        package.deps.difference_update([subpkg.name for subpkg in package.subpkgs])
    return package.recursive_dependencies(pkgs_map)

def get_list_cyclic_dependencies(pkgs_map, index=None, cache=None, pkgname=None, return_list=False, build_mode=False):
    "Find and print (or return a list of) circular dependencies for all packages or for one specified package."
    # is_root - indicates that the function was run for the first time.
    # Here such functions are called "root function".
    is_root = index == None
    if is_root:
        cache = {}
        index = []
    result = []

    # Start search
    if is_root:
        if pkgname:
            range_pkgs = [pkgname]
        else:
            range_pkgs = pkgs_map.keys()
    else:
        range_pkgs = pkgs_map[index[-1]].deps
        if build_mode:
            for subpkg in pkgs_map[index[-1]].subpkgs:
                if not subpkg.virtual:
                    range_pkgs |= subpkg.deps
            if index[-1] in range_pkgs:
                range_pkgs.remove(index[-1])
            for subpkg in pkgs_map[index[-1]].subpkgs:
                if subpkg.name in range_pkgs:
                    range_pkgs.remove(subpkg.name)

    for pkg in range_pkgs:
        if build_mode and isinstance(pkgs_map[pkg], TermuxSubPackage):
            pkg = pkgs_map[pkg].parent.name
        index.append(pkg)
        if index.count(pkg) == 2:
            result.append(index.copy() if pkgname else index[index.index(pkg)::])
        else:
            result += get_list_cyclic_dependencies(pkgs_map, index, cache, pkgname, build_mode=build_mode)
        del index[-1]

    # return result
    if is_root and not return_list:
        # If launched in a root function and the `return_list` variable is set to False,
        # then the result will be printed
        if len(result) == 0:
            print("No cyclic dependencies were found")
        else:
            print(f"Found {len(result)} cyclic dependencies:")
            for cycle in result:
                print("- "+" -> ".join(cycle))
    else:
        return result

def main():
    "Generate the build order either for all packages or a specific one."
    import argparse

    parser = argparse.ArgumentParser(description='Generate order in which to build dependencies for a package. Generates')
    parser.add_argument('-i', default=False, action='store_true',
                        help='Generate dependency list for fast-build mode. This includes subpackages in output since these can be downloaded.')
    parser.add_argument('-l', default=False, action='store_true',
			help='Return a list of packages (including subpackages) that have a circular dependency.')
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
        if full_buildorder:
            get_list_cyclic_dependencies(pkgs_map, build_mode=not(fast_build_mode))
        else:
            get_list_cyclic_dependencies(pkgs_map, pkgname=package.split("/")[-1], build_mode=not(fast_build_mode))
        sys.exit(0)

    if full_buildorder:
        build_order = generate_full_buildorder(pkgs_map)
    else:
        build_order = generate_target_buildorder(package, pkgs_map, fast_build_mode)

    for pkg in build_order:
        pkg_name = pkg.name
        if termux_global_library == "true" and termux_pkg_library == "glibc" and "glibc" not in pkg_name.split("-"):
            pkg_name = add_prefix_glibc_to_pkgname(pkgname)
        print("%-30s %s" % (pkg_name, pkg.dir))

if __name__ == '__main__':
    main()
