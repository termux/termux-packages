#!/bin/python3

from functools import cache
import logging
import os
import re
import time
from dataclasses import dataclass, field
from enum import Enum
from pathlib import Path
from typing import Dict, List, Set, Tuple, TypeAlias

logger = logging.getLogger(__name__)

logging.basicConfig(format="%(levelname)s: %(message)s", filename="order.log", filemode="w", level=logging.DEBUG)

DEPENDENCY_VARS = ("TERMUX_PKG_DEPENDS", "TERMUX_PKG_BUILD_DEPENDS", "TERMUX_SUBPKG_DEPENDS")

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


class BuildOrder:
    def __init__(self, root_pkg: PackageName | None, repos: List[Path], build_mode: BuildMode) -> None:
        if root_pkg is None and build_mode == BuildMode.ONLINE:
            raise Exception("Cannot generate full build order in online mode.")

        self.root_pkg = root_pkg
        self.repos = repos
        self.build_mode = build_mode

    def get(self) -> List[Package]:
        return self.__generate_order()

    def __parse_build_file_variable_bool(self, pkg_path: Path, var: str) -> bool:
        value = "false"

        with open(pkg_path / "build.sh", encoding="utf-8") as build_script:
            for line in build_script:
                if line.startswith(var):
                    value = line.split("=")[-1].replace("\n", "")
                    break

        return value == "true"

    def __parse_dependencies(self, path) -> Set[Dependency | AlternativeDependency]:
        dependencies = []

        with open(path, encoding="utf-8") as build_script:
            for m in re.findall(
                r'^(%s)[+]?="(.*?)"$' % "|".join(DEPENDENCY_VARS), build_script.read(), re.DOTALL | re.MULTILINE
            ):
                _, ds = m  # m: (DEPENDENCY_VAR, dependency string)

                arch = os.getenv("TERMUX_ARCH") or "aarch64"
                if arch == "x86_64":
                    arch = "x86-64"

                ds = re.sub(r"\${TERMUX_ARCH/_/-}", arch, ds)
                ds = re.sub(r"\(.*\)", "", ds)

                for d in ds.split(","):
                    if "|" in d:
                        dependencies.append(AlternativeDependency(options=tuple(re.findall(r"[\w+.-]+", d))))
                    else:
                        dependencies.append(d.strip())

        return set(dependencies)

    def __generate_package_map(self) -> PackageMap:
        package_map: Dict[PackageName, Package] = {}

        for repo in self.repos:
            for package_path in repo.iterdir():
                if self.__parse_build_file_variable_bool(package_path, "TERMUX_PKG_METAPACKAGE"):
                    package_map[package_path.name] = Package(
                        name=package_path.name,
                        path=package_path,
                        dependencies=self.__parse_dependencies(package_path / "build.sh"),
                        type=PackageType.VIRTUAL,
                    )
                    continue
                # Note for self: See page 6 of your notebook.
                dependencies = self.__parse_dependencies(package_path / "build.sh")
                subpackages = []

                for subpackage_path in package_path.glob("*.subpackage.sh"):
                    subpackage_name = subpackage_path.name.removesuffix(".subpackage.sh")
                    subpackage_dependencies: Set[Dependency | AlternativeDependency] = {package_path.name}
                    subpackage_type: PackageType = PackageType.VIRTUAL

                    if self.build_mode == BuildMode.OFFLINE:
                        dependencies.update(self.__parse_dependencies(subpackage_path))
                        subpackages.append(subpackage_name)

                    if self.build_mode == BuildMode.ONLINE:
                        subpackage_dependencies = self.__parse_dependencies(subpackage_path)
                        subpackage_type = PackageType.REAL

                    package_map[subpackage_name] = Package(
                        name=subpackage_name,
                        path=package_path,
                        dependencies=subpackage_dependencies,
                        type=subpackage_type,
                    )

                if self.build_mode == BuildMode.OFFLINE:
                    # Remove all the subpackages (of this parent) that might be in dependency set.
                    dependencies.difference_update(subpackages)  # Note for self: See page 7 of your notebook.
                    dependencies.discard(package_path.name)  # Some subpackages might have dependency on parent too.

                package_map[package_path.name] = Package(
                    name=package_path.name, path=package_path, dependencies=dependencies, type=PackageType.REAL
                )

                static_package = package_path.name + "-static"
                if static_package not in package_map:
                    if not self.__parse_build_file_variable_bool(package_path, "TERMUX_PKG_NO_STATICSPLIT"):
                        package_map[static_package] = Package(
                            name=static_package,
                            dependencies={package_path.name},
                            type=PackageType.VIRTUAL,
                            path=package_path,
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

        return build_order


repos = [
    repo
    for repo in (
        Path.cwd() / "../termux-packages" / "packages",
        Path.cwd() / "../termux-packages" / "root-packages",
        Path.cwd() / "../termux-packages" / "x11-packages",
    )
]

start_time = time.perf_counter()

for order in BuildOrder(None, repos, BuildMode.OFFLINE).get():
    print("%-40s %s" % (order.name, f"{order.path.parent.name}/{order.path.name}"))

end_time = time.perf_counter()

logger.debug("Elapsed time [total]: %f" % (end_time - start_time))


# INFO:
# - Two build modes: (OFFLINE: completely offline, ONLINE: completely online)
# ------------------------------------------------------------------------------------------------------
# [x] when in offline mode:
#   I do not need to consider subpackages, but since the way current packaging model
#   distributes some dependencies of the main package among the subpackages, we
#   need to add dependencies in `TERMUX_SUBPKG_DEPENDS` (of all subpackages) to the deps list of main package.
#   This ensures that we will be able to completely build the main package.
# ------------------------------------------------------------------------------------------------------
# [x] when in online mode:
#   I need to take care of subpackages as they can be downloaded too. Essentially, we need to consider subpackges
#   as independent packages (with dependecy on  main package: see 1st point).
#   Assumption:
#   `TERMUX_PKG_DEPENDS` lists all the packages that will be needed at runtime of this package. If not true then
#   defination of `TERMUX_PKG_DEPENDS` is contradictory.
