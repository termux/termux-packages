#!/usr/bin/env node
import { readFile } from "node:fs/promises";
import { gunzip } from "node:zlib";
import { promisify } from "node:util";
const gunzipAsync = promisify(gunzip);

const archs = ["aarch64", "arm", "i686", "x86_64"];

const repos = JSON.parse(await readFile("repo.json"));
if (repos.pkg_format != "debian") {
  console.error(`Unsupported package format: ${repos.pkg_format}`);
  process.exit(1);
}

function getComponentByRepoName(name) {
  for (const path in repos) {
    if (repos[path].name == name) {
      return repos[path].component;
    }
  }
  throw new Error(`Repository with name "${name}" not found`);
}

async function getAptPackages(repo, arch, errors, proposedFixes) {
  const url = `${repo.url}/dists/${repo.distribution}/${repo.component}/binary-${arch}/Packages.gz`;
  const response = await fetch(url);
  if (!response.ok) {
    throw new Error(
      `Failed to fetch ${url}: ${response.status} ${response.statusText}`,
    );
  }
  const data = await gunzipAsync(await response.arrayBuffer());
  const aptPackages = new Map();
  let pkgName = undefined;
  let pkgVersion = undefined;
  data
    .toString()
    .split("\n")
    .forEach((line) => {
      // console.debug(line);
      if (line.startsWith("Package: ")) {
        pkgName = line.substring("Package: ".length);
      } else if (line.startsWith("Version: ")) {
        pkgVersion = line.substring("Version: ".length);
      } else if (line == "") {
        if (pkgName && pkgVersion) {
          if (aptPackages.has(pkgName)) {
            errors.push(
              `Duplicate package: "${pkgName}" when parsing Packages file for "${repo.name}" for "${arch}"`,
            );
            proposedFixes.push(
              `# Duplicate package "${pkgName}" will likely be removed automatically once the cron job responsible for cleaning older versions of packages kicks in on the aptly server.`,
            );
          } else {
            // Only add the package version.
            // This also has a desired side-effect of only keeping the latest version since aptly seems to sort the Packages file
            aptPackages.set(pkgName, {
              version: pkgVersion,
              repo: repo.name,
            });
          }
        }
        pkgName = undefined;
        pkgVersion = undefined;
      }
    });
  if (pkgName || pkgVersion) {
    console.error(`Incomplete package entry in ${url}`);
    process.exit(1);
  }

  return aptPackages;
}

async function getTermuxPackages(arch, errors, proposedFixes) {
  const termuxPackages = new Map();
  const data = await readFile(
    `./scripts/apt-packages-list-${arch}.txt`,
    "utf8",
  );
  data
    .trim()
    .split("\n")
    .forEach((line) => {
      let [pkgName, pkgRepo, pkgVersion, pkgMayHaveStaticSubpkg] =
        line.split(" ");
      if (termuxPackages.has(pkgName)) {
        errors.push(`Duplicate package in termux-packages: "${pkgName}"`);
        proposedFixes.push(
          `# Duplicate package "${pkgName}" earlier found in "${termuxPackages.get(pkgName).repo}" also in "${pkgRepo}" needs to be removed from termux-packages`,
        );
      }
      termuxPackages.set(pkgName, {
        version: pkgVersion,
        repo: pkgRepo,
        mayHaveStaticSubpkg: pkgMayHaveStaticSubpkg === "true",
      });
    });
  return termuxPackages;
}

async function getErrorsForArch(arch) {
  const errors = [];
  const proposedFixes = [];
  const termuxPackages = await getTermuxPackages(arch, errors, proposedFixes);
  const aptPackages = new Map();
  for (const path in repos) {
    if (path == "pkg_format") continue;
    const repo = repos[path];

    // Get list of packages in apt repository and then add them to the map of all apt packages
    const currentAptRepoPackages = await getAptPackages(
      repo,
      arch,
      errors,
      proposedFixes,
    );
    for (const [pkgName, pkgInfo] of currentAptRepoPackages) {
      // Check if the package should exist in this repository in the first place
      if (termuxPackages.has(pkgName)) {
        // Check if the package is in the correct repo
        if (termuxPackages.get(pkgName).repo != pkgInfo.repo) {
          // If not in correct repo, then it must be removed
          errors.push(
            `Package "${pkgName}" exists in "${pkgInfo.repo}" but should be in "${termuxPackages.get(pkgName).repo}"`,
          );
          proposedFixes.push(
            `rm aptly-root/public/${pkgInfo.repo}/pool/${getComponentByRepoName(pkgInfo.repo)}/*/${pkgName}/${pkgName}_${pkgInfo.version}_${arch}.deb`,
          );
        } else {
          // If it's in the correct repo, make sure it is the same version as we have in termux-packages
          if (termuxPackages.get(pkgName).version != pkgInfo.version) {
            errors.push(
              `"${pkgName}" "${pkgInfo.version}" (in apt repository) != "${termuxPackages.get(pkgName).version}" (in termux-packages)`,
            );
            proposedFixes.push(
              `# The package "${pkgName}" in "${pkgInfo.repo}" may not be up to date on the apt repository or a bogus version may be present`,
            );
          }
          aptPackages.set(pkgName, pkgInfo);
        }
      } else {
        // If it's a static package, we need to repeat some of what we did earlier.
        // -static packages are automatically generated, so they may cease to exist in newer versions when no static libraries exist in newer versions of base package
        if (pkgName.endsWith("-static")) {
          const basePkgName = pkgName.substring(
            0,
            pkgName.length - "-static".length,
          );
          if (termuxPackages.has(basePkgName)) {
            // Check for TERMUX_PKG_NO_STATICSPLIT
            if (!termuxPackages.get(basePkgName).mayHaveStaticSubpkg) {
              errors.push(
                `"${pkgName}" ${pkgInfo.version}: static package should not exist as parent package "${basePkgName}" has TERMUX_PKG_NO_STATICSPLIT=true`,
              );
              proposedFixes.push(
                `rm aptly-root/public/${pkgInfo.repo}/pool/${getComponentByRepoName(pkgInfo.repo)}/*/${basePkgName}/${pkgName}_${pkgInfo.version}_${arch}.deb`,
              );
            } else {
              aptPackages.set(pkgName, pkgInfo);
            }
          } else {
            // This happens when the parent package was removed from the repository
            errors.push(
              `"${pkgName}" ${pkgInfo.version}: static package has no parent package`,
            );
            proposedFixes.push(
              `rm aptly-root/public/${pkgInfo.repo}/pool/${getComponentByRepoName(pkgInfo.repo)}/*/${basePkgName}/${pkgName}_${pkgInfo.version}_${arch}.deb`,
            );
          }
        } else {
          // It's not a static package, and it does not exists in termux-packages for that repository. So it should not exist
          errors.push(
            `"${pkgName}" "${pkgInfo.version}" does not exist in termux-packages`,
          );
          proposedFixes.push(
            `rm aptly-root/public/${pkgInfo.repo}/pool/${getComponentByRepoName(pkgInfo.repo)}/*/${pkgName}/${pkgName}_${pkgInfo.version}_${arch}.deb`,
          );
        }
      }
    }
  }

  // Now check for packages missing in apt repository but present in termux-packages
  for (const [termuxPkgName, termuxPkgInfo] of termuxPackages) {
    if (!aptPackages.has(termuxPkgName)) {
      errors.push(`"${termuxPkgName}" missing in apt repository`);
      proposedFixes.push(
        `# The package "${termuxPkgName}" in "${termuxPkgInfo.repo}" is missing in the apt repository, it likely needs to be rebuilt`,
      );
    } /* else {} */ // We already checked the versions for packages that exist in both maps
  }
  return {
    errors: errors,
    proposedFixes: proposedFixes,
  };
}

const promises = [];

for (const arch of archs) {
  promises.push(getErrorsForArch(arch));
}

const results = await Promise.all(promises);

let hasErrors = false;

for (let i = 0; i < archs.length; i++) {
  if (results[i].errors.length > 0) {
    console.log(`### Errors found for ${archs[i]}`);

    console.log("<details>");
    console.log("  <summary>Errors:</summary>");
    console.log("");
    console.log("```");
    console.log(results[i].errors.join("\n"));
    console.log("")
    console.log("```");
    console.log("</details>");

    console.log("\n\n");

    console.log("<details>");
    console.log("  <summary>Proposed fixes:</summary>");
    console.log("");
    console.log("```sh");
    console.log(results[i].proposedFixes.join("\n"));
    console.log("")
    console.log("```");
    console.log("</details>");
    console.log("\n\n\n\n");
    hasErrors = true;
  }
}

if (hasErrors) {
  process.exit(1);
}
