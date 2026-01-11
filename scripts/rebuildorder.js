#!/usr/bin/env node
// A helper script to obtain rebuild order of multiple packages

import { glob, readdir, readFile, stat } from "node:fs/promises";
import { basename, join } from "node:path";

if (process.argv.length < 3) {
  console.error("Usage:");
  console.error(
    "./scripts/rebuildorder.js <package1> [<package2> ... <packageN>]",
  );
  console.error(
    "where <package> are the packages you want to find the relative build order of",
  );
  console.error("Produces order of build");
  process.exit(1);
}

const repos = JSON.parse(await readFile("repo.json"));
const repoPaths = [];
for (const path in repos) {
  if (path == "pkg_format") continue;
  repoPaths.push(path);
}

const subPkgMap = new Map();
const pkgSet = new Set();

// First produce a mapping of subpackage to their parent package
// This is needed as some packages do specify their subpackage as their dependency
// in which case we are going to build the parent package itself
for (const repoPath of repoPaths) {
  for (const packageName of await readdir(repoPath)) {
    if ((await stat(join(repoPath, packageName))).isDirectory()) {
      if (pkgSet.has(packageName)) {
        console.error(`duplicate package '${packageName}' detected`);
        process.exit(1);
      }
      if (subPkgMap.has(packageName)) {
        console.error(`package '${packageName}' earlier found as subpackage`);
        process.exit(1);
      }
      pkgSet.add(packageName);
      for await (let subpackage of await glob(
        join(repoPath, packageName, "*.subpackage.sh"),
      )) {
        subpackage = basename(subpackage);
        subpackage = subpackage.substring(
          0,
          subpackage.length - ".subpackage.sh".length,
        );
        if (subPkgMap.has(subpackage)) {
          console.error(`duplicate subpackage '${subpackage}' detected`);
          process.exit(1);
        }
        if (pkgSet.has(subpackage)) {
          console.error(`duplicate subpackage '${subpackage}' detected`);
          process.exit(1);
        }
        subPkgMap.set(subpackage, packageName);
      }
    }
  }
}

function getDependencies(dependency_string) {
  // First getrid of the quotes
  if (dependency_string.startsWith("'") | dependency_string.startsWith('"')) {
    dependency_string = dependency_string.substring(1);
  }
  if (dependency_string.endsWith("'") | dependency_string.endsWith('"')) {
    dependency_string = dependency_string.substring(
      0,
      dependency_string.length - 1,
    );
  }
  // Now obtain separate all the dependencies
  let dependencies = new Set(dependency_string.split(","));
  // Now get rid of multiple dependency options
  for (const dependency of dependencies) {
    if (dependency.includes("|")) {
      dependencies.delete(dependency);
      for (const dep of dependency.split("|")) {
        dependencies.add(dep);
      }
    }
  }
  // Now finally time to extract the actual dependency names splitting any junk we don't want
  let newDependencies = new Set();
  for (const dependency of dependencies) {
    let dep = dependency.trim().match(/^[0-9a-z\-_\.\+]*/)[0];
    if (dep.length > 0) {
      newDependencies.add(dep);
    }
  }
  dependencies = newDependencies;
  for (const dependency of dependencies) {
    if (
      !pkgSet.has(dependency) &&
      !subPkgMap.has(dependency) &&
      dependency.endsWith("-static")
    ) {
      dependencies.delete(dependency);
      dependencies.add(
        dependency.substring(0, dependency.length - "-static".length),
      );
    }
  }
  for (const dependency of dependencies) {
    if (!pkgSet.has(dependency)) {
      if (subPkgMap.has(dependency)) {
        dependencies.delete(dependency);
        dependencies.add(subPkgMap.get(dependency));
      } else {
        // co
      }
    }
  }
  for (const dependency of dependencies) {
    if (
      !pkgSet.has(dependency) &&
      !subPkgMap.has(dependency) &&
      dependency != "swift-sdk-"
    ) {
      console.warn(`Warning Dependency '${dependency}' not found anywhere`);
    }
  }
  dependencies.delete("swift-sdk-");
  return dependencies;
}

function extractDependencyStrings(sh_file, variable_name) {
  let dependencyStrings = [];
  for (const line of sh_file.split("\n")) {
    if (line.includes(`${variable_name}=`)) {
      dependencyStrings.push(
        line.substring(
          line.indexOf(`${variable_name}=`) + `${variable_name}=`.length,
        ),
      );
    }
  }
  return dependencyStrings;
}

// Now generate the entire dependency tree of all the packages in the repository
// We are need to do this after generating subpackage mappings as subpackage names may too be in the package dependency list
let dependencyMap = new Map();

for (const repoPath of repoPaths) {
  for (const packageName of await readdir(repoPath)) {
    if ((await stat(join(repoPath, packageName))).isDirectory()) {
      let build_sh = await readFile(join(repoPath, packageName, "build.sh"));
      let dependencyStrings = extractDependencyStrings(
        build_sh.toString(),
        "TERMUX_PKG_DEPENDS",
      );
      for await (let subpackage of glob(
        join(repoPath, packageName, "*.subpackage.sh"),
      )) {
        let subpkg_sh = await readFile(subpackage);
        let subpkgDependencyStrings = extractDependencyStrings(
          subpkg_sh.toString(),
          "TERMUX_SUBPKG_DEPENDS",
        );
        for (const subpkgDepString of subpkgDependencyStrings) {
          dependencyStrings.push(subpkgDepString);
        }
      }
      let dependencies = new Set();
      for (const dependencyString of dependencyStrings) {
        dependencies = dependencies.union(getDependencies(dependencyString));
      }
      dependencies.delete(packageName);
      dependencyMap.set(packageName, dependencies);
    }
  }
}

// List of packages we want to rebuild
let rebuildPackages = new Set();
for (let i = 2; i < process.argv.length; i++) {
  let packageName = process.argv[i];
  if (subPkgMap.has(packageName)) {
    console.warn(
      `WARNING: autochanging subpackage '${packageName}' to '${subPkgMap.get(packageName)}'`,
    );
    packageName = subPkgMap.get(packageName);
  }
  packageName = packageName.substring(packageName.lastIndexOf("/") + 1); // Remove the repository name
  rebuildPackages.add(packageName);
}

// Verify all packages exist
for (const pkg of rebuildPackages) {
  if (!pkgSet.has(pkg)) {
    console.error(`Error: Package '${pkg}' not found`);
    process.exit(1);
  }
}

// Compute build order using topological sort (DFS-based)
function topologicalSort(packages, depMap) {
  const visited = new Set();
  const visiting = new Set();
  const order = [];

  function visit(pkg) {
    if (visited.has(pkg)) {
      return true;
    }
    if (visiting.has(pkg)) {
      console.error(`Circular dependency detected involving package '${pkg}'`);
      return false;
    }

    visiting.add(pkg);

    const deps = depMap.get(pkg);
    for (const dep of deps) {
      // Only consider dependencies that are in our rebuild set
      if (packages.has(dep)) {
        if (!visit(dep)) {
          return false;
        }
      }
    }

    visiting.delete(pkg);
    visited.add(pkg);
    order.push(pkg);
    return true;
  }

  for (const pkg of packages) {
    if (!visited.has(pkg)) {
      if (!visit(pkg)) {
        return null;
      }
    }
  }

  return order;
}

// Compute parallel build stages (Kahn's algorithm variant)
function computeBuildStages(packages, depMap) {
  // Count in-degrees (dependencies within our package set)
  const inDegree = new Map();
  const adjList = new Map();

  for (const pkg of packages) {
    inDegree.set(pkg, 0);
    adjList.set(pkg, new Set());
  }

  // Build adjacency list and count in-degrees
  for (const pkg of packages) {
    const deps = depMap.get(pkg);
    for (const dep of deps) {
      if (packages.has(dep)) {
        adjList.get(dep).add(pkg);
        inDegree.set(pkg, inDegree.get(pkg) + 1);
      }
    }
  }

  // Group packages into stages
  const stages = [];
  const processed = new Set();

  while (processed.size < packages.size) {
    const currentStage = [];

    // Find all packages with in-degree 0 (no unprocessed dependencies)
    for (const pkg of packages) {
      if (!processed.has(pkg) && inDegree.get(pkg) === 0) {
        currentStage.push(pkg);
      }
    }

    // We already checked for circular dependency earlier
    // if (currentStage.length === 0) {
    //   // Circular dependency detected
    //   console.error("Circular dependency detected - cannot compute stages");
    //   return null;
    // }

    // Process current stage
    for (const pkg of currentStage) {
      processed.add(pkg);

      // Decrease in-degree for dependent packages
      for (const dependent of adjList.get(pkg)) {
        inDegree.set(dependent, inDegree.get(dependent) - 1);
      }
    }

    stages.push(currentStage.sort());
  }

  return stages;
}

// Compute the build order
const buildOrder = topologicalSort(rebuildPackages, dependencyMap);

if (!buildOrder) {
  console.error("Failed to compute build order due to circular dependencies");
  process.exit(1);
}

// Compute parallel build stages
const buildStages = computeBuildStages(rebuildPackages, dependencyMap);

if (!buildStages) {
  process.exit(1);
}

// Output parallel build stages
console.log("\n=== Parallel Build Stages ===");
console.log(
  "(Packages in the same stage can be built independently/in parallel)\n",
);

for (let i = 0; i < buildStages.length; i++) {
  console.log(`Stage ${i + 1}: [${buildStages[i].length} package(s)]`);
  for (const pkg of buildStages[i]) {
    const deps = dependencyMap.get(pkg) || new Set();
    const relevantDeps = [...deps].filter((dep) => rebuildPackages.has(dep));
    if (relevantDeps.length > 0) {
      console.log(`  - ${pkg} (depends on: ${relevantDeps.join(", ")})`);
    } else {
      console.log(`  - ${pkg} (no dependencies)`);
    }
  }
  console.log();
}

// Summary statistics
console.log("=== Build Summary ===");
console.log(`Total packages to build: ${rebuildPackages.size}`);
console.log(`Total stages required: ${buildStages.length}`);
