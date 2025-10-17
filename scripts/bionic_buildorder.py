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
    _BUILD_SCRIPT_REGEX = re.compile(
        r"^(TERMUX_PKG_DEPENDS|TERMUX_PKG_BUILD_DEPENDS|TERMUX_PKG_METAPACKAGE|TERMUX_PKG_NO_STATICSPLIT)[+]?=[\"']?(.*?)[\"']?$",
        re.MULTILINE,
    )
    _SUBPACKAGE_SCRIPT_REGEX = re.compile(
        r"^(TERMUX_SUBPKG_DEPENDS|TERMUX_SUBPKG_DEPEND_ON_PARENT)[+]?=[\"']?(.*?)[\"']?$", re.MULTILINE
    )

    def __init__(self, script_path: Path) -> None:
        self.variables: Dict[str, str] = {}
        regex = self._BUILD_SCRIPT_REGEX if script_path.name == "build.sh" else self._SUBPACKAGE_SCRIPT_REGEX
        for m in regex.finditer(script_path.read_text(encoding="utf-8")):
            if m:
                var, value = m.groups()
                if self.variables.setdefault(var, value) != value:
                    self.variables[var] += f",{value}"

    def is_metapackage(self) -> bool:
        return self.variables.get("TERMUX_PKG_METAPACKAGE", "false") == "true"

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
        self._package_map: Dict[PackageName, Path] = self._create_package_map()
        logger.debug("Total packages in repo: %d" % len(self._package_map))

    def _create_package_map(self) -> Dict[PackageName, Path]:
        package_map = {}
        for repo in self.repos:
            for package_path in repo.iterdir():
                for subpackage_path in package_path.glob("*.subpackage.sh"):
                    package_map[subpackage_path.name.removesuffix(".subpackage.sh")] = subpackage_path
                package_map[package_path.name] = package_path / "build.sh"
        return package_map

    def generate_order(self) -> List[Package]:
        build_order: List[Package] = []

        stack: List[Tuple[PackageName, bool]] = []
        visited: Set[PackageName] = set()  # Contains nodes that have been fully explored.
        path: List[PackageName] = []

        def dfs():
            while stack:
                node, is_backtracking = stack.pop()
                package = self._get_package(node)

                if is_backtracking:
                    path.pop()
                    visited.add(node)
                    build_order.append(package)
                    continue

                if node in visited:
                    continue

                stack.append((node, True))  # Backtracking.
                path.append(node)

                resolved_deps = []
                for dep in package.dependencies:
                    # Why this skip?
                    # initially: dotnet8.0 -> dotnet-host -> dotnet-host-8.0 | dotnet-host-9.0
                    # resolved: dotnet8.0 -> dotnet8.0 | dotnet9.0
                    # Since, dotnet8.0 is in resolved AlternativeDependency, dotnet-host is built "out of" dotnet8.0.
                    # Hence, we skip.
                    resolved_deps.extend(
                        d
                        for d in self._resolve_dependencies(dep)
                        if not (isinstance(d, AlternativeDependency) and package.name in d.options)
                    )

                for dep in resolved_deps:
                    if isinstance(dep, AlternativeDependency):
                        dep = next(iter(visited.intersection(dep.options)), dep.default)
                    if dep in path:
                        raise Exception("Cycle exists: %s" % (path[path.index(dep) :] + [dep]))
                    if dep not in visited:
                        stack.append((dep, False))

        if self.root_pkg:
            if self._get_package(self.root_pkg).type == PackageType.VIRTUAL:
                die("%s is either a metapackage or subpackage. Exiting..." % self.root_pkg)
            stack.append((self.root_pkg, False))
            dfs()
        else:
            for pkg in self._package_map.keys():
                if pkg not in visited and self._get_package(pkg).type != PackageType.VIRTUAL:
                    stack.append((pkg, False))
                    dfs()

        logger.debug("Total in build_order: %d", len(build_order))

        build_order.pop()  # Remove root_pkg from the set.
        return build_order

    @cache
    def _get_package(self, package_name: PackageName) -> Package:
        # A non-existent, virtual static package:
        if package_name.endswith("-static") and package_name not in self._package_map:
            parent = package_name.removesuffix("-static")
            return Package(package_name, PackageType.VIRTUAL, self._package_map[parent].parent, {parent})

        if package_name not in self._package_map:
            die("%s is a non-existent package." % package_name)

        package_script_path = self._package_map[package_name]
        package_path = package_script_path.parent

        # For root package we are always in OFFLINE mode as we are building it:
        build_mode = BuildMode.OFFLINE if package_name == self.root_pkg else self.build_mode

        package_info = self._parse_build_script(package_script_path)
        dependencies = package_info.get_dependencies(build_mode)

        if package_info.is_metapackage():
            return Package(package_name, PackageType.VIRTUAL, package_path, dependencies)

        if package_script_path.name.endswith(".subpackage.sh"):
            parent = package_path.name
            if build_mode == BuildMode.OFFLINE:
                return Package(package_name, PackageType.VIRTUAL, package_path, {parent})
            # See ./build/termux_create_debian_subpackages.sh#L104 to understand the this behaviour:
            parent_deps = self._parse_build_script(package_path / "build.sh").get_dependencies(build_mode)
            match package_info.subpackage_relation_with_parent():
                case "true" | "yes" | "unversioned" if package_name not in parent_deps:
                    dependencies.add(parent)
                case "deps":
                    dependencies.update(parent_deps)
            return Package(package_name, PackageType.REAL, package_path, dependencies)

        if build_mode == BuildMode.OFFLINE:
            subpackages = []
            for subpackage_path in package_path.glob("*.subpackage.sh"):
                dependencies.update(self._parse_build_script(subpackage_path).get_dependencies(build_mode))
                subpackages.append(subpackage_path.name.removesuffix(".subpackage.sh"))
            # Remove all the subpackages (of this parent) that might be in it's dependency set.
            dependencies.difference_update(subpackages)
            # Some subpackages might explicitly list dependence on parent.
            dependencies.discard(package_name)

        # This is not needed for metapackages and subpackages.
        if TERMUX_ON_DEVICE_BUILD:
            for d in ON_DEVICE_ALWAYS_DEPENDENCIES:
                if package_name != d:
                    dependencies.add(d)

        return Package(package_name, PackageType.REAL, package_path, dependencies)

    @cache
    def _parse_build_script(self, script_path: Path) -> BuildScriptParser:
        return BuildScriptParser(script_path)

    @cache
    def _resolve_dependencies(self, dep: Dependency | AlternativeDependency):
        if isinstance(dep, AlternativeDependency):
            flattened_options = []
            for d in dep.options:
                flattened_options.extend(self._resolve_dependencies(d))
            return [AlternativeDependency(options=tuple(flattened_options))]

        package = self._get_package(dep)

        if package.type == PackageType.REAL:
            return [dep]

        flattened_dependencies = []
        for d in package.dependencies:
            flattened_dependencies.extend(self._resolve_dependencies(d))
        return flattened_dependencies


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

    for order in BuildOrder(package, repos, build_mode).generate_order():
        package_name = order.name

        logger.debug("%-40s %s" % (package_name, f"{order.path.parent.name}/{order.path.name}"))
        print("%-40s %s" % (package_name, f"{order.path.parent.name}/{order.path.name}"))

end_time = time.perf_counter()

logger.debug("Elapsed time [total]: %f" % (end_time - start_time))
