#!/usr/bin/env node
//
// A script to check for checking difference between apt repository and
// termux-packages
//
// Currently checks the following:
// - Missing packages in apt repository
// - Version mismatches in apt repository and termux-packages
// - Packages in apt repository that shouldn't exist (this may happen when a
//   packages is removed in termux-packages, but wasn't removed from the apt
//   repository)
//
import { readFile } from "node:fs/promises";
import { gunzip } from "node:zlib";
import { promisify } from "node:util";
import { execFile } from "node:child_process";
const gunzipAsync = promisify(gunzip);
const execFileAsync = promisify(execFile);

const archs = ["aarch64", "arm", "i686", "x86_64"];

if (process.argv.length != 3) {
  console.error("Usage:");
  console.error("./scripts/check-repository-health.js <path-to-output>");
  console.error(
    "  where '<path-to-output>' is the path to directory where ./scripts/generate-apt-packages-list.sh has run",
  );
  process.exit(1);
}

const outputDir = process.argv[2];

const repos = JSON.parse(await readFile("repo.json"));
if (repos.pkg_format != "debian") {
  console.error(`Unsupported package format: ${repos.pkg_format}`);
  process.exit(1);
}
const repoPathMap = new Map();
for (const path in repos) {
  if (path == "pkg_format") continue;
  const repo = repos[path];
  if (repoPathMap.has(repo.name)) {
    console.error("Multiple repository paths with same repository name.");
    console.error(
      "This should not be happening. repo.json file needs to be fixed",
    );
    console.error(
      `Repository "${repo.name}" also exists for path "${path}" when it already existed for "${repoPathMap.get(path)}"`,
    );
    process.exit(1);
  }
  repoPathMap.set(repo.name, path);
}

async function getAptPackages(
  repo,
  arch,
  errors,
  _proposedAutomatedFixes,
  proposedManualFixes,
  termuxPackages,
) {
  // https://wiki.debian.org/DebianRepository/Format#A.22Packages.22_Indices
  // The Packages file is a gzipped file containing a list of packages names,
  // descriptions, versions and other info. Different entries are separated by
  // an additional new line.

  // First fetch the Packages.gz file for the repository and architecture
  const url = `${repo.url}/dists/${repo.distribution}/${repo.component}/binary-${arch}/Packages.gz`;
  const response = await fetch(url);
  if (!response.ok) {
    throw new Error(
      `Failed to fetch ${url}: ${response.status} ${response.statusText}`,
    );
  }
  // gunzip the file to get the actual content
  const data = await gunzipAsync(await response.arrayBuffer());

  // Now parse the file file and generate a map of package names to their
  // version and repository name.
  const aptPackages = new Map();
  let pkgName = undefined;
  let pkgVersion = undefined;
  let pkgFilename = undefined;
  data
    .toString()
    .split("\n")
    .forEach(async (line) => {
      // Package: <package-name>
      if (line.startsWith("Package: ")) {
        pkgName = line.substring("Package: ".length);
      }
      // Version: <package-version>
      else if (line.startsWith("Version: ")) {
        pkgVersion = line.substring("Version: ".length);
      } else if (line.startsWith("Filename: ")) {
        pkgFilename = line.substring("Filename: ".length);
      }
      // New line indicates the end of a package entry
      else if (line == "") {
        if (pkgName && pkgVersion && pkgFilename) {
          if (aptPackages.has(pkgName)) {
            const currentTime = Math.floor(new Date().getTime() / 1000);
            let lastModified = currentTime;
            if (termuxPackages.has(pkgName)) {
              lastModified = termuxPackages.get(pkgName).lastModified;
            }
            // Only make this an error if the oldest deb with for the same package is older than 24 hours. The cron job on the server running aptly runs once every 6 hours, 24 hour is a bit more reasonable to make sure we don't fill errors that should not be there in case the cron job fails due to some reason
            if (currentTime - lastModified >= 3600 * 24) {
              errors.push(
                `Duplicate package: "${pkgName}" when parsing Packages file for "${repo.name}" for "${arch}"`,
              );
              proposedManualFixes.push(
                `Duplicate package "${pkgName}" will likely be removed automatically once the cron job responsible for cleaning older versions of packages kicks in on the aptly server.`,
              );
            }
            try {
              await execFileAsync("dpkg", [
                "--compare-versions",
                pkgVersion,
                "ge",
                aptPackages.get(pkgName).version,
              ]);
              aptPackages.get(pkgName).version = pkgVersion;
            } catch (e) {}
          } else {
            // Only add the package version.
            aptPackages.set(pkgName, {
              version: pkgVersion,
              filename: pkgFilename,
              repo: repo.name,
            });
          }
        }
        pkgName = undefined;
        pkgFilename = undefined;
        pkgVersion = undefined;
      }
    });
  // There should be extra newline at the end of the file, so this should
  // never be true, but just in case we check it to ensure we parsed the file
  // correctly.
  if (pkgName || pkgVersion || pkgFilename) {
    console.error(`Incomplete package entry in ${url}`);
    process.exit(1);
  }

  return aptPackages;
}

// Returns a map of package names to their version, repository name and whether
// the package may have a -static subpackage.
async function getTermuxPackages(
  arch,
  errors,
  _proposedAutomatedFixes,
  proposedManualFixes,
) {
  const termuxPackages = new Map();
  // "${outputDir}/apt-packages-list-${arch}.txt" is a file generated by
  // `./scripts/generate-apt-packages-list.sh` script
  const data = await readFile(
    `${outputDir}/apt-packages-list-${arch}.txt`,
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
        proposedManualFixes.push(
          `Duplicate package "${pkgName}" earlier found in "${termuxPackages.get(pkgName).repo}" also in "${pkgRepo}" needs to be removed from termux-packages`,
        );
      }
      const { stdout } = execFileAsync("git", [
        "log",
        "-1",
        "--format=%at",
        `${repoPathMap.get(pkgRepo)}`,
      ]);
      const lastModified = Number.parseInt(stdout);
      termuxPackages.set(pkgName, {
        version: pkgVersion,
        repo: pkgRepo,
        mayHaveStaticSubpkg: pkgMayHaveStaticSubpkg === "true",
        lastModified,
      });
    });
  return termuxPackages;
}

async function getErrorsForArch(arch) {
  const errors = [];
  // This is a shell script which the maintainers can simply run on the aptly
  // server to fix all errors that can the script was able to figure out the
  // fix for.
  const proposedAutomatedFixes = [];
  const proposedManualFixes = [];
  const termuxPackages = await getTermuxPackages(
    arch,
    errors,
    proposedAutomatedFixes,
    proposedManualFixes,
  );
  const aptPackages = new Map();
  for (const path in repos) {
    if (path == "pkg_format") continue;
    const repo = repos[path];

    // Get list of packages in apt repository and then add them to the map of all apt packages
    const currentAptRepoPackages = await getAptPackages(
      repo,
      arch,
      errors,
      proposedAutomatedFixes,
      proposedManualFixes,
      termuxPackages,
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
          proposedAutomatedFixes.push(
            `aptly repo remove "${pkgInfo.repo}" "${pkgName} (=${pkgInfo.version}) {${arch}}"`,
          );
        } else {
          // If it's in the correct repo, make sure it is the same version as we have in termux-packages
          if (termuxPackages.get(pkgName).version != pkgInfo.version) {
            errors.push(
              `"${pkgName}" "${pkgInfo.version}" (in apt repository) != "${termuxPackages.get(pkgName).version}" (in termux-packages)`,
            );
            proposedManualFixes.push(
              `The package "${pkgName}" in "${pkgInfo.repo}" may not be up to date on the apt repository or a bogus version may be present`,
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
              proposedAutomatedFixes.push(
                `aptly repo remove "${pkgInfo.repo}" "${pkgName} (=${pkgInfo.version}) {${arch}}"`,
              );
            } else {
              if (termuxPackages.get(basePkgName).version != pkgInfo.version) {
                errors.push(
                  `"${pkgName}" "${pkgInfo.version}" != ${termuxPackages.get(basePkgName).version} as expected by parent package. The -static package probably stopped existing after an update.`,
                );
                proposedAutomatedFixes.push(
                  `aptly repo remove "${pkgInfo.repo}" "${pkgName} (=${pkgInfo.version}) {${arch}}"`,
                );
              }
              aptPackages.set(pkgName, pkgInfo);
            }
          } else {
            // This happens when the parent package was removed from the repository
            errors.push(
              `"${pkgName}" ${pkgInfo.version}: static package has no parent package`,
            );
            proposedAutomatedFixes.push(
              `aptly repo remove "${pkgInfo.repo}" "${pkgName} (=${pkgInfo.version}) {${arch}}"`,
            );
          }
        } else {
          // It's not a static package, and it does not exists in termux-packages for that repository. So it should not exist
          errors.push(
            `"${pkgName}" "${pkgInfo.version}" does not exist in termux-packages`,
          );
          proposedAutomatedFixes.push(
            `aptly repo remove "${pkgInfo.repo}" "${pkgName} (=${pkgInfo.version}) {${arch}}"`,
          );
        }
      }
    }
  }

  // Now check for packages missing in apt repository but present in termux-packages
  for (const [termuxPkgName, termuxPkgInfo] of termuxPackages) {
    if (!aptPackages.has(termuxPkgName)) {
      errors.push(`"${termuxPkgName}" missing in apt repository`);
      proposedManualFixes.push(
        `The package "${termuxPkgName}" in "${termuxPkgInfo.repo}" is missing in the apt repository, it likely needs to be rebuilt`,
      );
    } /* else {} */ // We already checked the versions for packages that exist in both maps
  }
  return {
    errors,
    proposedAutomatedFixes,
    proposedManualFixes,
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
    console.log("");
    console.log("```");
    console.log("</details>");

    console.log("\n\n");

    console.log("<details>");
    console.log("  <summary>Proposed Automated fixes:</summary>");
    console.log("");
    console.log("```sh");
    console.log(results[i].proposedAutomatedFixes.join("\n"));
    console.log("");
    console.log("```");
    console.log("</details>");
    console.log("\n\n");

    console.log("<details>");
    console.log("  <summary>Proposed Manual fixes:</summary>");
    console.log("");
    console.log("```");
    console.log(results[i].proposedManualFixes.join("\n"));
    console.log("");
    console.log("```");
    console.log("</details>");
    console.log("\n\n\n\n");
    hasErrors = true;
  }
}

if (hasErrors) {
  process.exit(1);
}
