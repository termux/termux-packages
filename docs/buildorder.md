# Documentation for `new_buildorder.py`

This script is used to determine the order in which to build the dependencies of a given package. It performs a topological sort (post-order Depth First Traversal) on the dependency graph to generate a linear order.

---

## Concepts

* **`Package`**: Something which has a build script (`build.sh`) or a subpackage script (`*.subpackage.sh`).
A package can be one of two types:
  * **`REAL`**: A package that compiles to an artifact when built.
  * **`VIRTUAL`**: A concept package that doesn't produce any artifacts. It just acts as a placeholder or an alias to one or more `REAL` packages. For example: Metapackages, `static` packages, and subpackages (in `OFFLINE` mode).

* **Build Modes**: There are two modes of operation:
  * **`BuildMode.OFFLINE`**: It assumes no access to pre-built packages. The package and all its dependencies are to be built from source. It considers **build-time dependencies** (`TERMUX_PKG_BUILD_DEPENDS`) in addition to runtime dependencies.
  * **`BuildMode.ONLINE`**: This mode assumes pre-built packages can be downloaded. It only considers runtime dependencies (`TERMUX_PKG_DEPENDS`), as build dependencies are not needed.

> [!NOTE]
> The `root_pkg` is always operated in `BuildMode.OFFLINE` as it has be built from source.

* **`AlternativeDependency`**: Represents a choice between several possible dependencies (e.g., `libA | libB`). It holds a tuple of options and assumes the first one as the default.

---

## Dependency Graph

It is represented as a [memoized](https://docs.python.org/3/library/functools.html#functools.cache) `__get_package` function.

### `__get_package(package_name)`

This function parses a package's build script and creates a `Package` object. `Package` creation logic differs based on the package type and build mode.

* **Virtual Static Packages**: If a package name ends in `-static` and has no corresponding build script, it's treated as a `VIRTUAL` package that simply depends on its parent.
* **Metapackages**: Packages with `TERMUX_PKG_METAPACKAGE="true"` are marked as `VIRTUAL`.
* **Subpackages**:
  * In **`OFFLINE` mode**, a subpackage is considered `VIRTUAL`. It cannot be built separately, as it's created during the parent package's build process. Its only depends upon its parent.
  * In **`ONLINE` mode**, a subpackage is considered as `REAL` because it can be downloaded independently. `TERMUX_SUBPKG_DEPENDS` are its dependencies.

### `__resolve_dependencies(package)`

This function eliminates all the `VIRTUAL` packages from the graph. If package `A` depends upon a `VIRTUAL` package `V`, and `V` in provided by/depends upon  a `REAL` packages `B`, this function ensures that the DFS sees `A`'s dependencies as `B`, not `V`.

It works recursively:

1. If a dependency is `REAL`, it's returned as is.
2. If a dependency is `VIRTUAL`, the function calls itself on that package's dependencies until it flattens them all back to `REAL` packages.

## Refrences

<https://en.wikipedia.org/wiki/Tree_traversal>
