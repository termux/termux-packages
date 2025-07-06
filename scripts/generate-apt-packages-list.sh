#!/usr/bin/env bash
set -e

# This script generates a list of packages with their versions and other details to make it easier for parsing by check-repository-consistency.js
# Outputs scripts/apt-packages-list-<arch>.txt for each architecture
#
# Format of each line:
# <package_name> <repo-name> <version> <may_have_staticsplit>

TERMUX_PACKAGES_DIR="$(realpath "$(dirname "$(realpath "$0")")/..")"
repo_paths=$(jq --raw-output 'del(.pkg_format) | keys | .[]' "$TERMUX_PACKAGES_DIR/repo.json")

for arch in "aarch64" "arm" "i686" "x86_64"; do
	for repo_path in ${repo_paths[@]}; do
		repo_name=$(jq --raw-output ".\"$repo_path\".name" "$TERMUX_PACKAGES_DIR/repo.json")
		package_paths=($TERMUX_PACKAGES_DIR/$repo_path/*)
		for pkg_path in "${package_paths[@]}"; do
			(
				. "$pkg_path/build.sh" &> /dev/null || :
				# We are erraneously adding a revision for packages with version containing a dash when generating the apt packages in our build scripts.
				# So reproduce the same bug here
        # Source: scripts/build/termux_extract_dep_info.sh
				#	if [[ "$TERMUX_PKG_REVISION" != "0" || "$TERMUX_PKG_VERSION" != "${TERMUX_PKG_VERSION/-/}" ]]; then
				#		VER_DEBIAN+="-$TERMUX_PKG_REVISION"
				# fi

				if [[ "${TERMUX_PKG_VERSION/-/}" != "${TERMUX_PKG_VERSION}" ]] && [[ "$TERMUX_PKG_REVISION" == "" ]]; then
					export TERMUX_PKG_REVISION=0
				fi
				IFS="," read -r -a EXCLUDED_ARCHES <<< "${TERMUX_PKG_EXCLUDED_ARCHES:-}"
				excluded=false
				for excluded_arch in ${EXCLUDED_ARCHES[@]}; do
					if [[ "$excluded_arch" = "$arch" ]]; then
						excluded=true
					fi
				done
				if [[ "$excluded" != true ]]; then
					if [[ -d "$pkg_path" ]]; then
						if [[ "$TERMUX_PKG_REVISION" != "" ]]; then
							echo -n "$(basename "$pkg_path") $repo_name $TERMUX_PKG_VERSION-$TERMUX_PKG_REVISION"
						else
							echo -n "$(basename "$pkg_path") $repo_name $TERMUX_PKG_VERSION"
						fi
					fi
					if [[ "$TERMUX_PKG_NO_STATICSPLIT" = true ]]; then
						echo " false"
					else
						echo " true"
					fi
					for subpkg in "$pkg_path"/*.subpackage.sh; do
						if [[ -f "$subpkg" ]]; then
							(
								. "$subpkg" &> /dev/null || :
								IFS="," read -r -a SUBPKG_EXCLUDED_ARCHES <<< "${TERMUX_SUBPKG_EXCLUDED_ARCHES:-}"
								excluded=false
								for excluded_subpkg_arch in ${SUBPKG_EXCLUDED_ARCHES[@]}; do
									if [[ "$excluded_subpkg_arch" = "$arch" ]]; then
										excluded=true
									fi
								done
								if [[ "$excluded" != true ]]; then
									if [[ "$TERMUX_PKG_REVISION" != "" ]]; then
										echo "$(basename "$(basename "$subpkg" .subpackage.sh)") $repo_name $TERMUX_PKG_VERSION-$TERMUX_PKG_REVISION false"
									else
										echo "$(basename "$(basename "$subpkg" .subpackage.sh)") $repo_name $TERMUX_PKG_VERSION false"
									fi
								fi
							)
						fi
					done
				fi
			)
		done
	done > "$TERMUX_PACKAGES_DIR/scripts/apt-packages-list-$arch.txt" & # Parallelize each architecture
done

wait
