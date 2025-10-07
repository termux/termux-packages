#!/bin/python3

import logging
import os
import re
import time
from dataclasses import dataclass, field
from enum import Enum
from functools import cache
from pathlib import Path
from typing import Dict, List, Set, Tuple, TypeAlias

logger = logging.getLogger(__name__)


TERMUX_ON_DEVICE_BUILD = os.getenv("TERMUX_ON_DEVICE_BUILD") == "true"
TERMUX_GLOBAL_LIBRARY = os.getenv("TERMUX_GLOBAL_LIBRARY") == "true"
TERMUX_PACKAGE_LIBRARY = os.getenv("TERMUX_PACKAGE_LIBRARY", "bionic")
TERMUX_ARCH = os.getenv("TERMUX_ARCH", "aarch64").replace("x86_64", "x86-64")

ON_DEVICE_ALWAYS_DEPENDENCIES = ("libc++",)

PackageName: TypeAlias = str
Dependency: TypeAlias = PackageName


def die(msg: str) -> None:
    print("ERROR:", msg)
    exit(1)


class BuildMode(Enum):
    ONLINE = 0
    OFFLINE = 1


class PackageType(Enum):
    REAL = 0
    VIRTUAL = 1


@dataclass()
class AlternativeDependency:
    options: Tuple[Dependency]
    default: Dependency = field(init=False)

    def __post_init__(self) -> None:
        self.default = self.options[0]  # By default choose first option.

    def __hash__(self) -> int:
        return hash(self.options)


@dataclass()
class Package:
    name: PackageName
    type: PackageType
    path: Path
    dependencies: Set[Dependency | AlternativeDependency]

    def __hash__(self) -> int:
        return hash(self.name)


class BuildScriptParser:
    _VARS_REGEX = re.compile(
        r"""
        ^(
        TERMUX_PKG_METAPACKAGE
        | TERMUX_PKG_NO_STATICSPLIT
        | TERMUX_PKG_BUILD_DEPENDS
        | TERMUX_PKG_DEPENDS
        | TERMUX_SUBPKG_DEPENDS
        | TERMUX_SUBPKG_DEPEND_ON_PARENT
        )
        [+]?=["']?(.*?)["']?$
        """,
        re.MULTILINE | re.VERBOSE,
    )

    def __init__(self, script_path: Path) -> None:
        self.variables: Dict[str, str] = {}

        for m in self._VARS_REGEX.finditer(script_path.read_text(encoding="utf-8")):
            if m:
                var, value = m.groups()
                if self.variables.setdefault(var, value) != value:
                    self.variables[var] += f",{value}"

    def is_metapackage(self) -> bool:
        return self.variables.get("TERMUX_PKG_METAPACKAGE", "false") == "true"

    def is_static_splitting_allowed(self) -> bool:
        return self.variables.get("TERMUX_PKG_NO_STATICSPLIT", "false") != "true"

    def subpackage_relation_with_parent(self) -> str:
        # Default to having dependence on parent.
        return self.variables.get("TERMUX_SUBPKG_DEPEND_ON_PARENT", "true")

    def get_dependencies(self, build_mode: BuildMode) -> Set[Dependency | AlternativeDependency]:
        keys = ["TERMUX_PKG_DEPENDS", "TERMUX_SUBPKG_DEPENDS"]
        if build_mode == BuildMode.OFFLINE:
            keys.append("TERMUX_PKG_BUILD_DEPENDS")

        ds = ",".join(self.variables[k] for k in keys if k in self.variables)

        ds = re.sub(r"\${TERMUX_ARCH/_/-}", TERMUX_ARCH, ds)
        ds = re.sub(r"\(.*\)", "", ds)

        return {
            AlternativeDependency(options=tuple(re.findall(r"[\w+.-]+", d))) if "|" in d else d.strip()
            for d in ds.split(",")
            if d
        }


class BuildOrder:
    def __init__(self, root_pkg: PackageName | None, repos: List[Path], build_mode: BuildMode) -> None:
        self.root_pkg = root_pkg
        self.repos = repos
        self.build_mode = build_mode

        # A map of package name to it's build script:
        self._package_map: Dict[PackageName, Path] = {}

        for repo in self.repos:
            for package_path in repo.iterdir():
                package_name = package_path.name

                for subpackage_path in package_path.glob("*.subpackage.sh"):
                    self._package_map[subpackage_path.name.removesuffix(".subpackage.sh")] = subpackage_path

                self._package_map[package_name] = package_path / "build.sh"

        logger.debug("Total packages in repo: %d" % len(self._package_map))

    def generate_order(self) -> List[Package]:
        build_order: List[Package] = []

        stack: List[Tuple[PackageName, bool]] = []
        visited: Set[PackageName] = set()  # Contains nodes that have been fully explored.
        path: List[PackageName] = []

        def dfs():
            while stack:
                node, is_backtracking = stack.pop()
                package = self.__get_package(node)

                if is_backtracking:
                    path.pop()
                    visited.add(node)
                    build_order.append(package)
                    continue

                if node in visited:
                    continue

                stack.append((node, True))  # Backtracking.
                path.append(node)

                for dep in self.__resolve_dependencies(package):
                    if isinstance(dep, AlternativeDependency):
                        dep = next(iter(visited.intersection(dep.options)), dep.default)
                    if dep in path:
                        raise Exception("Cycle exists: %s" % (path[path.index(dep) :] + [dep]))
                    if dep not in visited:
                        stack.append((dep, False))

        if self.root_pkg:
            if self.__get_package(self.root_pkg).type == PackageType.VIRTUAL:
                die("%s is either a metapackage or subpackage. Exiting..." % self.root_pkg)
            stack.append((self.root_pkg, False))
            dfs()
        else:
            for pkg in self._package_map.keys():
                if pkg not in visited and self.__get_package(pkg).type != PackageType.VIRTUAL:
                    stack.append((pkg, False))
                    dfs()

        logger.debug("Total in build_order: %d", len(build_order))

        build_order.pop()  # Remove root_pkg from the set.
        return build_order

    @cache
    def __get_package(self, package_name: PackageName) -> Package:
        # A non-existent, virtual static package:
        if package_name.endswith("-static") and package_name not in self._package_map:
            parent = package_name.removesuffix("-static")
            return Package(
                name=package_name,
                dependencies={parent},
                type=PackageType.VIRTUAL,
                path=self._package_map[parent].parent,
            )

        # It should exist now.
        if package_name not in self._package_map:
            die("%s is a non-existent package." % package_name)

        package_script_path = self._package_map[package_name]
        package_path = package_script_path.parent

        # For root package we are always in OFFLINE mode as we are building it:
        build_mode = BuildMode.OFFLINE if package_name == self.root_pkg else self.build_mode

        package_info = self.__parse_build_script(package_script_path)
        dependencies = package_info.get_dependencies(build_mode)

        if package_info.is_metapackage():
            return Package(name=package_name, path=package_path, dependencies=dependencies, type=PackageType.VIRTUAL)

        if package_script_path.name.endswith(".subpackage.sh"):
            if build_mode == BuildMode.OFFLINE:
                return Package(
                    name=package_name, path=package_path, dependencies={package_path.name}, type=PackageType.VIRTUAL
                )
            else:
                # See the following link to understand this behaviour:
                # https://github.com/termux/termux-packages/blob/abdfb2a00f7d2f2bdd6de42a1a085948c68c050c/scripts/build/termux_create_debian_subpackages.sh#L104
                match package_info.subpackage_relation_with_parent():
                    case "true" | "unversioned" if package_name not in dependencies:
                        dependencies.add(package_path.name)  # Parent.
                    case "deps":
                        dependencies.update(self.__parse_build_script(package_path).get_dependencies(build_mode))
                return Package(name=package_name, path=package_path, dependencies=dependencies, type=PackageType.REAL)

        if build_mode == BuildMode.OFFLINE:
            subpackages = []

            for subpackage_path in package_path.glob("*.subpackage.sh"):
                dependencies.update(self.__parse_build_script(subpackage_path).get_dependencies(build_mode))
                subpackages.append(subpackage_path.name.removesuffix(".subpackage.sh"))

            # Remove all the subpackages (of this parent) that might be in it's dependency set.
            dependencies.difference_update(subpackages)
            dependencies.discard(package_name)  # Some subpackages might explicitly list dependence on parent.

        # This is not needed for metapackages and subpackages.
        if TERMUX_ON_DEVICE_BUILD and TERMUX_PACKAGE_LIBRARY == "bionic":
            for d in ON_DEVICE_ALWAYS_DEPENDENCIES:
                if package_name != d:
                    dependencies.add(d)

        return Package(name=package_name, path=package_path, dependencies=dependencies, type=PackageType.REAL)

    @cache
    def __parse_build_script(self, script_path: Path) -> BuildScriptParser:
        return BuildScriptParser(script_path)

    @cache
    def __resolve_dependencies(self, package: Package) -> List[Dependency | AlternativeDependency]:
        def resolve(dep: Dependency | AlternativeDependency):
            if isinstance(dep, AlternativeDependency):
                flattened_options = []
                for d in dep.options:
                    flattened_options.extend(resolve(d))
                return [AlternativeDependency(options=tuple(flattened_options))]

            package = self.__get_package(dep)

            if package.type == PackageType.REAL:
                return [dep]

            flattened_dependencies = []
            for d in package.dependencies:
                flattened_dependencies.extend(resolve(d))
            return flattened_dependencies

        resolved_deps = []
        for dep in package.dependencies:
            # Why this skip?
            # initially: dotnet8.0 -> dotnet-host -> dotnet-host-8.0 | dotnet-host-9.0
            # resolved: dotnet8.0 -> dotnet8.0 | dotnet9.0
            # Since, dotnet8.0 is in resolved AlternativeDependency, dotnet-host is built "out of" dotnet8.0.
            # Hence, we skip.
            resolved_deps.extend(
                d for d in resolve(dep) if not (isinstance(d, AlternativeDependency) and package.name in d.options)
            )
        return resolved_deps


start_time = time.perf_counter()

if __name__ == "__main__":
    import argparse

    parser = argparse.ArgumentParser(
        description="Generate order in which to build dependencies of a package.",
        epilog="Crafted with <3 by @MrAdityaAlok",
    )
    parser.add_argument(
        "-i",
        action="store_true",
        help="Generate build order in ONLINE mode. This includes subpackages in output since they can be downloaded. [Not compatible with ONLINE mode]",
    )
    parser.add_argument(
        "package", nargs="?", help="Package to generate build order for. [Can be skipped to generate full buildorder]"
    )
    parser.add_argument(
        "repos", nargs="*", type=Path, help="Directories with packages. [Defaults to those specified in repo.json]"
    )

    args = parser.parse_args()

    package: str = args.package

    build_mode = BuildMode.OFFLINE
    if args.i:
        if not package:
            die("-i (ONLINE) mode has no meaning when building all packages")
        build_mode = BuildMode.ONLINE

    repos: List[Path] = args.repos
    if not repos:
        from json import load as json_load

        try:
            with open("./repo.json") as f:
                repos = []
                for d in json_load(f).keys():
                    if d != "pkg_format":
                        repos.append(Path(Path.cwd() / d))
        except FileNotFoundError:
            die("'repo.json' file not found at %s. Check script location." % Path.cwd())

    # TEMP
    log_dir = Path("./log")
    log_dir.mkdir(exist_ok=True)

    logging.basicConfig(
        format="%(levelname)s: %(message)s",
        filename=log_dir / f"{package or 'full'}-buildorder.log",
        filemode="w",
        level=logging.DEBUG,
    )

    logger.debug(f"""Called with following info:
    package: {package},
    repos: {repos}
    build_mode: {build_mode}
    """)
    # END TEMP

    for order in BuildOrder(package, repos, build_mode).generate_order():
        package_name = order.name

        logger.debug("%-40s %s" % (package_name, f"{order.path.parent.name}/{order.path.name}"))
        print("%-40s %s" % (package_name, f"{order.path.parent.name}/{order.path.name}"))

end_time = time.perf_counter()

logger.debug("Elapsed time [total]: %f" % (end_time - start_time))
