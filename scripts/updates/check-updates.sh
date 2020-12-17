#!/usr/bin/env bash
set -e -u
BASEDIR=$(dirname "$(realpath "$0")")

# Do 'export BUILD_PACKAGES=true' to automatically built the updated packages.
: "${BUILD_PACKAGES:=false}"

if [ -z "${GITHUB_API_TOKEN-}" ]; then
	echo "You need a Github Personal Access Token be set in variable GITHUB_API_TOKEN."
	exit 1
fi

if [ -f "${BASEDIR}/github-projects.txt" ]; then
	while read -r line; do
		unset package project version_regexp
		package=$(echo "$line" | cut -d'|' -f1)
		project=$(echo "$line" | cut -d'|' -f2)
		version_regexp=$(echo "$line" | cut -d'|' -f3-)

		if [ ! -d "${BASEDIR}/../../packages/${package}" ]; then
			echo "Package '$package' is not available, skipping."
		fi

		# Our local version of package.
		termux_version=$(set +e +u;. "${BASEDIR}/../../packages/${package}/build.sh" 2>/dev/null; echo "$TERMUX_PKG_VERSION" | cut -d: -f2-)

		# Latest version is the current release tag on Github.
		latest_version=$(curl --silent -H "Authorization: token ${GITHUB_API_TOKEN}" "https://api.github.com/repos/${project}/releases/latest" | jq -r .tag_name)

		# Remove leading 'v' which is common in version tag.
		latest_version=${latest_version#v}

		# If needed, filter version numbers from tag by using regexp.
		if [ -n "$version_regexp" ]; then
			latest_version=$(grep -oP "$version_regexp" <<< "$latest_version")
		fi

		# We have no better choice for comparing versions.
		if [ "$(echo -e "${termux_version}\n${latest_version}" | sort -V | head -n 1)" != "$latest_version" ] ;then
			if [ "$BUILD_PACKAGES" = "false" ]; then
				echo "Package '${package}' needs update to '${latest_version}'."
			else
				echo "Updating '${package}' to '${latest_version}'."
				sed -i "s/^\(TERMUX_PKG_VERSION=\)\(.*\)\$/\1${latest_version}/g" "${BASEDIR}/../../packages/${package}/build.sh"
				sed -i "/TERMUX_PKG_REVISION=/d" "${BASEDIR}/../../packages/${package}/build.sh"
				echo n | "${BASEDIR}/../bin/update-checksum" "$package"

				echo "Trying to build package '${package}'."
				"${BASEDIR}/../run-docker.sh" ./build-package.sh -a aarch64 -I "$package"
			fi
		fi
	done < <(grep -P '^[a-z0-9]' "${BASEDIR}/github-projects.txt")
fi
