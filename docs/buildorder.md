# Build Order Generation

This script is used to determine the order in which to build the dependencies
of a given package. It performs a topological sort
(post-order Depth First Traversal) on the dependency graph to generate a linear order.

## Core Concepts

### PackageType

All packages are divided into two categories:

- `REAL`: A standard package that can be compiled.
- `VIRTUAL`: A package that isn't a *real* package but points to one or more
other packages. For example: static packages and metapackages.

### BuildMode

There are two modes of operation:

- `ONLINE`: Assumes subpackages can be downloaded and treats them as separate, `REAL` packages. They only have relation with their parent as defined by `TERMUX_SUBPKG_DEPEND_ON_PARENT`
- `OFFLINE`: Assumes no network access. It merges the dependencies of subpackages into their parent package, and treats them as `VIRTUAL` packages
(as they cannot be built independently).

### Dependencies

Dependencies are simply `REAL` or `VIRTUAL` packages on which a package depends.

There is a special type of dependency:

- `AlternativeDependency`: It represents a choice between several possible dependencies (e.g., `libA` | `libB`). It holds a tuple of options and assumes the first one as the default.

## BuildOrder

### Dependency graph

A dictionary (`PackageMap`) mapping of package to `Package` is built. Each package of every repo is processed.

#### Step 1

##### Metapackages

Marked as `VIRTUAL` packages and added to the graph.

##### Subpackages

The logic differs based on the `build_mode`:

- `OFFLINE`: Dependencies from all subpackages are merged into the parent package. The subpackages themselves are treated as `VIRTUAL` packages that simply depend on the parent. This ensures the parent package has everything it needs to build completely.
- `ONLINE`: Subpackages are treated as independent `REAL` packages. Their dependencies are parsed, and a dependency on the parent package is added based on the `TERMUX_SUBPKG_DEPEND_ON_PARENT` flag.

##### Static Packages

If a package allows static splitting, a `VIRTUAL` package with a `-static` suffix is created, with dependency on the main package.

#### Step 2 (Sanitization)

The `VIRTUAL` packages are resolved to `REAL` packages that provide them. The `resolve` function recursively traverses the dependencies of a `VIRTUAL` package until it finds the `REAL` package that provides it. This flattens the dependency chain to only include `REAL` packages.

### Order Generation

A *post-order* Depth-First Search (DFS) algorithm is applied to the sanitized package map. It uses a `path` list to detect cycles.

#### DFS Traversal

The algorithm traverses the dependency graph starting from the `root_pkg` (if provided) or all packages. It recursively explores the dependencies of each package.

##### Cycle Detection

If it encounters a package that is already in the current traversal path, it means a circular dependency exists, and it raises an exception.

Once all dependencies of a package have been visited, the package is added to the final `build_order` list. The resulting list is the correct build order, where each package appears after all of its dependencies.

##### Choice of AlternativeDependency

An option from `AlternativeDependency` is determined using `next(iter(visited.intersection(dep.options)), dep.default)` logic. It ensures that if one of the options is already selected, we do not make a redundant choice.

## Refrences

<https://en.wikipedia.org/wiki/Tree_traversal>
