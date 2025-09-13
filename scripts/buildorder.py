#!/usr/bin/env python3
"Script to generate a build order respecting package dependencies."

import json, os, re, sys, traceback

from graphlib import CycleError
from graphlib import TopologicalSorter
from itertools import filterfalse

termux_arch = os.getenv('TERMUX_ARCH') or 'aarch64'
termux_global_library = os.getenv('TERMUX_GLOBAL_LIBRARY') or 'false'
termux_pkg_library = os.getenv('TERMUX_PACKAGE_LIBRARY') or 'bionic'


MAX_LOG_LEVEL = 5 # Default: `5` (VVVERBOSE=5)
LOG_LEVEL = 1 # Default: `1` (OFF=0, NORMAL=1, DEBUG=2, VERBOSE=3, VVERBOSE=4 and VVVERBOSE=5)
try:
    log_level = os.getenv('TERMUX_PKGS__BUILD_ORDER__LOG_LEVEL')
    if log_level:
        log_level = int(log_level)
        if log_level >= 0 and log_level <= MAX_LOG_LEVEL:
            LOG_LEVEL = log_level
except ValueError:
    pass

def log_error(string):
    if LOG_LEVEL >= 1:
        print(string, file=sys.stderr)

def log_error_debug(string):
    if LOG_LEVEL >= 2:
        print(string, file=sys.stderr)

def log_error_verbose(string):
    if LOG_LEVEL >= 3:
        print(string, file=sys.stderr)

def log_error_vverbose(string):
    if LOG_LEVEL >= 4:
        print(string, file=sys.stderr)

def log_error_vvverbose(string):
    if LOG_LEVEL >= 5:
        print(string, file=sys.stderr)



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
    print(msg, file=sys.stderr)
    sys.exit(1)

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
    # - https://github.com/termux/termux-packages/commit/6e70277f
    return parse_build_file_dependencies_with_vars(path, ('TERMUX_PKG_DEPENDS', 'TERMUX_PKG_BUILD_DEPENDS', 'TERMUX_SUBPKG_DEPENDS'))

def parse_build_file_antidependencies(path):
    "Extract the antidependencies of a build.sh file."
    return parse_build_file_dependencies_with_vars(path, 'TERMUX_PKG_ANTI_BUILD_DEPENDS')

def parse_build_file_excluded_arches(path):
    "Extract the excluded arches specified in a build.sh or *.subpackage.sh file."
    arches = []

    with open(path, encoding="utf-8") as build_script:
        for line in build_script:
            if line.startswith(('TERMUX_PKG_EXCLUDED_ARCHES', 'TERMUX_SUBPKG_EXCLUDED_ARCHES')):
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
        if "gpkg" in self.dir.split("/")[-2].split("-") and not has_prefix_glibc(self.name):
            self.name = add_prefix_glibc_to_pkgname(self.name)

        # search package build.sh
        build_sh_path = os.path.join(self.dir, 'build.sh')
        if not os.path.isfile(build_sh_path):
            raise Exception("build.sh not found for package '" + self.name + "'")

        self.deps = parse_build_file_dependencies(build_sh_path)
        self.original_deps = self.deps.copy()
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

    def recursive_dependencies(self, pkgs_map, build_graph, recursed_pkgs, indent, dir_root=None):
        "All the dependencies of the package, both direct and indirect."
        log_error_verbose("%sp_start(%s) deps: %s" % (' ' * indent, self.name, ','.join(sorted(self.deps))))

        result = []
        is_root = dir_root is None
        if is_root:
            dir_root = self.dir
        if is_root or not self.fast_build_mode or not self.separate_subdeps:
            for subpkg in self.subpkgs:
                if f"{self.name}-static" != subpkg.name:
                    if os.getenv('TERMUX_ORIG_PKG_NAME') != subpkg.name and \
                        os.getenv('TERMUX_PKGS__BUILD__NO_BUILD_UNNEEDED_SUBPACKAGES') == "true" and \
                        subpkg.name not in self.original_deps:
                        if LOG_LEVEL >= 3:
                            log_error_debug("%sNot adding subpackage \"%s\" of package \"%s\" since its not a dependency of parent package and TERMUX_PKGS__BUILD__NO_BUILD_UNNEEDED_SUBPACKAGES is enabled" % (' ' * indent, subpkg.name, self.name))
                        else:
                            log_error_debug("Not adding subpackage \"%s\" of package \"%s\" since its not a dependency of parent package and TERMUX_PKGS__BUILD__NO_BUILD_UNNEEDED_SUBPACKAGES is enabled" % (subpkg.name, self.name))
                        continue
                    self.deps.add(subpkg.name)
                    self.deps |= subpkg.deps
            self.deps -= self.antideps

            # Do not depend on itself.
            self.deps.discard(self.name)

            # Do not depend on any sub package.
            if not self.fast_build_mode or self.dir == dir_root:
                self.deps.difference_update([subpkg.name for subpkg in self.subpkgs])

        log_error_vverbose("%sp_loop(%s) deps: %s" % (' ' * indent, self.name, ','.join(sorted(self.deps))))
        for dependency_name in sorted(self.deps):
            if termux_global_library == "true" and termux_pkg_library == "glibc" and not has_prefix_glibc(dependency_name):
                mod_dependency_name = add_prefix_glibc_to_pkgname(dependency_name)
                dependency_name = mod_dependency_name if mod_dependency_name in pkgs_map else dependency_name

            dependency_package = pkgs_map[dependency_name]
            if dependency_name not in recursed_pkgs:
                recursed_pkgs.add(dependency_name)
                if dependency_package.dir != dir_root and dependency_package.only_installing and not self.fast_build_mode:
                    continue

                result += dependency_package.recursive_dependencies(pkgs_map, build_graph, recursed_pkgs, indent + 4, dir_root)

                if dependency_package.accept_dep_scr or dependency_package.dir != dir_root:
                    result += [dependency_package]
                    dependency_edge = add_node_to_build_graph(build_graph, self, dependency_package)
                    if dependency_edge:
                        log_error_verbose("%sp_add(%s): dep: %s: %s" % (' ' * (indent + 4), self.name, dependency_name, dependency_edge))
            else:
                if dependency_package.accept_dep_scr or dependency_package.dir != dir_root:
                    dependency_edge = add_node_to_build_graph(build_graph, self, dependency_package)
                    if dependency_edge:
                        log_error_verbose("%sp_readd(%s): dep: %s: %s" % (' ' * (indent + 4), self.name, dependency_name, dependency_edge))

        result = list(unique_everseen(result))
        log_error_verbose("%sp_end(%s) res: %s" % (' ' * indent, self.name, ','.join([p.name for p in result])))
        return result

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

    def recursive_dependencies(self, pkgs_map, build_graph, recursed_pkgs, indent, dir_root=None):
        """All the dependencies of the subpackage, both direct and indirect.
        Only relevant when building in fast-build mode"""
        log_error_verbose("%ss_start(%s) deps: %s" % (' ' * indent, self.name, ','.join(sorted(self.deps))))

        result = []
        if dir_root is None:
            dir_root = self.dir

        log_error_vverbose("%ss_loop(%s) deps: %s" % (' ' * indent, self.name, ','.join(sorted(self.deps))))
        for dependency_name in sorted(self.deps):
            # Do not depend parent on current subpackage.
            if dependency_name == self.parent.name:
                self.parent.deps.discard(self.name)

            dependency_package = pkgs_map[dependency_name]
            if dependency_name not in recursed_pkgs:
                recursed_pkgs.add(dependency_name)

                if dependency_package not in self.parent.subpkgs:
                    result += dependency_package.recursive_dependencies(pkgs_map, build_graph, recursed_pkgs, indent + 4, dir_root=dir_root)

                if dependency_package.accept_dep_scr or dependency_package.dir != dir_root:
                    result += [dependency_package]
                    dependency_edge = add_node_to_build_graph(build_graph, self, dependency_package)
                    if dependency_edge:
                        log_error_verbose("%ss_add(%s): dep: %s: %s" % (' ' * (indent + 4), self.name, dependency_name, dependency_edge))
            else:
                if dependency_package.accept_dep_scr or dependency_package.dir != dir_root:
                    dependency_edge = add_node_to_build_graph(build_graph, self, dependency_package)
                    if dependency_edge:
                        log_error_verbose("%ss_readd(%s): dep: %s: %s" % (' ' * (indent + 4), self.name, dependency_name, dependency_edge))

        result = list(unique_everseen(result))
        log_error_verbose("%ss_end(%s) res: %s" % (' ' * indent, self.name, ','.join([p.name for p in result])))
        return result

def add_node_to_build_graph(build_graph, package, dependency_package):
    package_name = package.parent.name if isinstance(package, TermuxSubPackage) else package.name
    dependency_package_name = dependency_package.parent.name if isinstance(dependency_package, TermuxSubPackage) else dependency_package.name

    if package_name != dependency_package_name:
        build_graph.add(package_name, dependency_package_name)
        return "(%s -> %s)" % (dependency_package_name, package_name)
    else:
        return None

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
        log_error("ERROR: Cycle exists. Remaining: ")
        for name, pkg in pkgs_map.items():
            if pkg not in build_order:
                log_error("%s: " % (name, str(remaining_deps[name])))

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
            log_error(f"cycle: {' -> '.join(cycle)}")

        sys.exit(1)

    return build_order

def generate_target_buildorder(target_path, pkgs_map, fast_build_mode):
    "Generate a build order for building the dependencies of the specified package."
    if target_path.endswith('/'):
        target_path = target_path[:-1]

    target_package_name = os.path.basename(target_path)
    if "gpkg" in target_path.split("/")[-2].split("-") and "glibc" not in target_package_name.split("-"):
        target_package_name += "-glibc"

    target_package = pkgs_map[target_package_name]

    # Do not depend on any sub package.
    if fast_build_mode:
        target_package.deps.difference_update([subpkg.name for subpkg in target_package.subpkgs])

    recursed_pkgs = set()
    build_graph = TopologicalSorter()
    legacy_build_order = target_package.recursive_dependencies(pkgs_map, build_graph, recursed_pkgs, 0)

    log_error_debug("\n\nlegacy_build_order(%s):" % target_package_name)
    print_build_order(legacy_build_order, False, True)

    try:
        log_error_debug("\n\ntopological_build_order(%s):" % target_package_name)
        topological_build_order = []
        topological_build_order_package_names = [*build_graph.static_order()]
        topological_build_order_len = len(topological_build_order_package_names)

        for index, package_name in enumerate(topological_build_order_package_names):
            if index == topological_build_order_len - 1 and package_name == target_package_name:
                continue
            topological_build_order.append(pkgs_map[package_name])

        print_build_order(topological_build_order, False, True)

        log_error("Returning topological_build_order(%s): %s" % (target_package_name, str([pkg.name for pkg in topological_build_order])))

        return topological_build_order
    except CycleError as e:
        if os.getenv('TERMUX_PKGS__BUILD_ORDER__RETURN_LEGACY_TARGET_BUILD_ORDER_ON_CYCLE') == "true":
            log_error("Failed to generate target build order as cycle found: " + str(e))
            log_error("Returning legacy_build_order(%s): %s" % (target_package_name, str([pkg.name for pkg in legacy_build_order])))
            return legacy_build_order

        die("Failed to generate target build order as cycle found: " + str(e))

def print_build_order(build_order, to_stdout=True, log=False):
    for pkg in build_order:
        pkg_name = pkg.name
        if termux_global_library == "true" and termux_pkg_library == "glibc" and not has_prefix_glibc(pkg_name):
            pkg_name = add_prefix_glibc_to_pkgname(pkg_name)
        if to_stdout:
            print("%-30s %s" % (pkg_name, pkg.dir))
        if log:
            log_error_debug("%-30s %s" % (pkg_name, pkg.dir))

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
        log_error_debug("Running full buildorder")
    else:
        full_buildorder = False
        log_error_debug("Running buildorder for package: " + package)

    if fast_build_mode and full_buildorder:
        die('-i mode does not work when building all packages')

    try:
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

        print_build_order(build_order)

    except Exception:
        die('Failed to generate build order:\n' + traceback.format_exc())

if __name__ == '__main__':
    main()
