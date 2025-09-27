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


TERMUX_ARCH = (os.getenv("TERMUX_ARCH") or "aarch64").replace("x86_64", "x86-64")

PackageName: TypeAlias = str
Dependency: TypeAlias = PackageName


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

    def __eq__(self, value: object, /) -> bool:
        if not isinstance(value, AlternativeDependency):
            return NotImplemented
        return value == self.options

    def __hash__(self) -> int:
        return hash(self.options)


@dataclass()
class Package:
    name: PackageName
    type: PackageType
    path: Path
    dependencies: Set[Dependency | AlternativeDependency]


PackageMap: TypeAlias = Dict[PackageName, Package]


class BuildScriptParser:
    def __init__(self, script_path: Path) -> None:
        with open(script_path, encoding="utf-8") as build_script:
            self.content = build_script.read()

    def __parse_bool_variable(self, var: str) -> bool:
        value = "false"

        m = re.search(r'^%s="?(true|false)"?$' % var, self.content, re.MULTILINE)
        if m:
            value = m.group(1)

        return value == "true"

    def is_metapackage(self) -> bool:
        return self.__parse_bool_variable("TERMUX_PKG_METAPACKAGE")

    def is_static_splitting_allowed(self) -> bool:
        return not self.__parse_bool_variable("TERMUX_PKG_NO_STATICSPLIT")

    def subpackage_relation_with_parent(self) -> str:
        m = re.search(r'^TERMUX_SUBPKG_DEPEND_ON_PARENT="?(true|false|deps|unversioned)"?$', self.content, re.MULTILINE)
        if m:
            return m.group(1)
        return "true"  # Default to having dependence on parent.

    def get_dependencies(self, build_mode: BuildMode) -> Set[Dependency | AlternativeDependency]:
        dependencies = []

        for m in re.findall(
            # TERMUX_PKG_BUILD_DEPENDS should only list dependencies required at build time.
            r'^(TERMUX_PKG_DEPENDS|TERMUX_SUBPKG_DEPENDS%s)[+]?="(.*?)"$'
            % ("|TERMUX_PKG_BUILD_DEPENDS" if build_mode == BuildMode.OFFLINE else ""),
            self.content,
            re.DOTALL | re.MULTILINE,
        ):
            _, ds = m  # m: (DEPENDENCY_VAR, dependency string)

            ds = re.sub(r"\${TERMUX_ARCH/_/-}", TERMUX_ARCH, ds)
            ds = re.sub(r"\(.*\)", "", ds)

            for d in ds.split(","):
                if "|" in d:
                    dependencies.append(AlternativeDependency(options=tuple(re.findall(r"[\w+.-]+", d))))
                else:
                    dependencies.append(d.strip())

        return set(dependencies)


class BuildOrder:
    def __init__(self, root_pkg: PackageName | None, repos: List[Path], build_mode: BuildMode) -> None:
        self.root_pkg = root_pkg
        self.repos = repos
        self.build_mode = build_mode

    def get(self) -> List[Package]:
        return self.__generate_order()

    def __generate_package_map(self) -> PackageMap:
        package_map: Dict[PackageName, Package] = {}

        for repo in self.repos:
            for package_path in repo.iterdir():
                package_info = BuildScriptParser(package_path / "build.sh")

                package_name = package_path.name
                # For root package we are in OFFLINE mode as we are building it:
                build_mode = BuildMode.OFFLINE if package_name == self.root_pkg else self.build_mode

                dependencies = package_info.get_dependencies(build_mode)

                if package_info.is_metapackage():
                    package_map[package_name] = Package(
                        name=package_name, path=package_path, dependencies=dependencies, type=PackageType.VIRTUAL
                    )
                    continue

                # Note for self: See page 6 of your notebook.
                if build_mode == BuildMode.OFFLINE:
                    subpackages = []

                    # NOTE: When package_name == self.root_pkg, we do not need to add subpackges as
                    # no one should depend upon them (will cause circular dependency otherwise), but we
                    # add them to catch circular dependencies later in __generate_order.

                    for subpackage_path in package_path.glob("*.subpackage.sh"):
                        subpackage_name = subpackage_path.name.removesuffix(".subpackage.sh")

                        dependencies.update(BuildScriptParser(subpackage_path).get_dependencies(build_mode))
                        subpackages.append(subpackage_name)

                        package_map[subpackage_name] = Package(
                            name=subpackage_name,
                            path=package_path,
                            dependencies={package_name},
                            type=PackageType.VIRTUAL,
                        )

                    # Remove all the subpackages (of this parent) that might be in it's dependency set.
                    dependencies.difference_update(subpackages)  # Note for self: See page 7 of your notebook.
                    dependencies.discard(package_name)  # Some subpackages might explicitly list dependence on parent.
                else:
                    for subpackage_path in package_path.glob("*.subpackage.sh"):
                        subpackage_name = subpackage_path.name.removesuffix(".subpackage.sh")
                        subpackage_info = BuildScriptParser(subpackage_path)
                        subpackage_dependencies = subpackage_info.get_dependencies(build_mode)

                        # See the following link to understand this behaviour:
                        # https://github.com/termux/termux-packages/blob/abdfb2a00f7d2f2bdd6de42a1a085948c68c050c/scripts/build/termux_create_debian_subpackages.sh#L104
                        match subpackage_info.subpackage_relation_with_parent():
                            case "true" | "unversioned" if subpackage_name not in dependencies:
                                subpackage_dependencies.add(package_name)
                            case "deps":
                                subpackage_dependencies.update(dependencies)

                        package_map[subpackage_name] = Package(
                            name=subpackage_name,
                            path=package_path,
                            dependencies=subpackage_dependencies,
                            type=PackageType.REAL,
                        )

                package_map[package_name] = Package(
                    name=package_name, path=package_path, dependencies=dependencies, type=PackageType.REAL
                )

                static_package = package_name + "-static"
                if static_package not in package_map and package_info.is_static_splitting_allowed():
                    package_map[static_package] = Package(
                        name=static_package, dependencies={package_name}, type=PackageType.VIRTUAL, path=package_path
                    )

        sanitized_map: PackageMap = {}

        @cache
        def resolve(dep: Dependency | AlternativeDependency) -> List[Dependency | AlternativeDependency]:
            if isinstance(dep, AlternativeDependency):
                flattened_options = []
                for d in dep.options:
                    flattened_options.extend(resolve(d))
                return [AlternativeDependency(options=tuple(flattened_options))]

            if package_map[dep].type == PackageType.REAL:
                return [dep]

            # For PackageType.VIRTUAL:
            flattened_dependencies = []
            for d in package_map[dep].dependencies:
                flattened_dependencies.extend(resolve(d))
            return flattened_dependencies

        for package in package_map.values():
            if package.type == PackageType.REAL:
                sanitized_deps = []
                for dep in package.dependencies:
                    # Why this skip?
                    # initially: dotnet8.0 -> dotnet-host -> dotnet-host-8.0 | dotnet-host-9.0
                    # resolved: dotnet8.0 -> dotnet8.0 | dotnet9.0
                    # Since, dotnet8.0 is in resolved AlternativeDependency, dotnet-host is built "out of" dotnet8.0.
                    # Hence, we skip.
                    logger.debug("Resloving '%s' ==> %s", dep, resolve(dep))
                    sanitized_deps.extend(
                        d
                        for d in resolve(dep)
                        if not (isinstance(d, AlternativeDependency) and package.name in d.options)
                    )
                sanitized_map[package.name] = Package(
                    name=package.name, path=package.path, dependencies=set(sanitized_deps), type=package.type
                )

        return sanitized_map

    def __generate_order(self) -> List[Package]:
        package_map: PackageMap = self.__generate_package_map()

        logger.debug("Total packages in repo: %d" % len(package_map))

        build_order: List[Package] = []

        stack: List[Tuple[PackageName, bool]] = []
        visited: Set[PackageName] = set()  # Contains nodes that have been fully explored.
        path: List[PackageName] = []

        def dfs():
            while stack:
                node, is_backtracking = stack.pop()

                package = package_map[node]

                if is_backtracking:
                    path.pop()
                    visited.add(node)
                    build_order.append(package)
                    continue

                if node in visited:
                    continue

                stack.append((node, True))  # Backtracking.
                path.append(node)
                logger.debug("'%s' depends upon: %s", package.name, package.dependencies)
                for dep in package.dependencies:
                    if isinstance(dep, AlternativeDependency):
                        dep = next(iter(visited.intersection(dep.options)), dep.default)
                    if dep in path:
                        raise Exception("Cycle exists: %s" % (path[path.index(dep) :] + [dep]))
                    if dep not in visited:
                        stack.append((dep, False))

        if self.root_pkg:
            stack.append((self.root_pkg, False))
            dfs()
        else:
            for pkg in package_map.keys():
                if pkg not in visited:
                    stack.append((pkg, False))
                    dfs()

        logger.debug("Total in build_order: %d", len(build_order))

        build_order.pop()  # Remove self.root_pkg from list.
        return build_order


def die(msg: str) -> None:
    print("ERROR:", msg)
    exit(1)


def main() -> None:
    import argparse

    parser = argparse.ArgumentParser(
        description="Generate order in which to build dependencies of a package.",
        epilog="Crafted with <3 by @MrAdityaAlok",
    )
    parser.add_argument(
        "-i",
        default=False,
        action="store_true",
        help="Generate build order in ONLINE mode. This includes subpackages in output since they can be downloaded. [Not compatible with ONLINE mode]",
    )
    parser.add_argument(
        "package",
        nargs="?",
        default=None,
        help="Package to generate build order for. [Can be skipped to generate full buildorder]",
    )
    parser.add_argument(
        "package_dirs",
        nargs="*",
        type=Path,
        help="Directories with packages. [Defaults to those specified in repo.json]",
    )
    args = parser.parse_args()

    online_build_mode: bool = args.i
    package: str = args.package
    package_directories: List[Path] = args.package_dirs

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
    package_directories: {package_directories}
    online_build_mode: {online_build_mode}
    """)

    full_buildorder = True if not package else False

    if online_build_mode and full_buildorder:
        die("-i (ONLINE) mode has no meaning when building all packages")

    if not package_directories:
        import json

        try:
            with open("./repo.json") as f:
                package_directories = []
                for d in json.load(f).keys():
                    if d != "pkg_format":
                        package_directories.append(Path(Path.cwd() / d))
        except FileNotFoundError:
            die("'repo.json' file not found at %s. Check script location." % Path.cwd())

    for order in BuildOrder(
        root_pkg=package,
        build_mode=BuildMode.ONLINE if online_build_mode else BuildMode.OFFLINE,
        repos=package_directories,
    ).get():
        logger.debug("%-40s %s" % (order.name, f"{order.path.parent.name}/{order.path.name}"))
        print("%-40s %s" % (order.name, f"{order.path.parent.name}/{order.path.name}"))


start_time = time.perf_counter()

if __name__ == "__main__":
    main()

end_time = time.perf_counter()

logger.debug("Elapsed time [total]: %f" % (end_time - start_time))

# TODO: Add support for glibc
