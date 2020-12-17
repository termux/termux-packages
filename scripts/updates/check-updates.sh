#!/usr/bin/env bash
set -e -u
BASEDIR=$(dirname "$(realpath "$0")")

if [ -z "${GITHUB_API_TOKEN-}" ]; then
	echo "You need a Github Personal Access Token be set in variable GITHUB_API_TOKEN."
	exit 1
fi

if [ -f "${BASEDIR}/github-projects.txt" ]; then
	while read -r line; do
		package=$(echo "$line" | cut -d'|' -f1)
		project=$(echo "$line" | cut -d'|' -f2-)

		if [ ! -d "${BASEDIR}/../../packages/${package}" ]; then
			echo "Package '$package' is not available, skipping."
		fi

		# Our local version of package.
		termux_version=$(. "${BASEDIR}/../../packages/${package}/build.sh" 2>/dev/null; echo "$TERMUX_PKG_VERSION")

		# Latest version is the current release tag on Github.
		latest_version=$(curl --silent -H "Authorization: token ${GITHUB_API_TOKEN}" "https://api.github.com/repos/${project}/releases/latest" | jq -r .tag_name)

		# Remove leading 'v' which is common in version tag.
		latest_version=${latest_version#v}

		# We have no better choice for comparing versions.
		if [ "$(echo -e "${termux_version}\n${latest_version}" | sort -V | head -n 1)" != "$latest_version" ] ;then
			echo "Package '${package}' needs update to '${latest_version}'."
		fi
	done < "${BASEDIR}/github-projects.txt"
fi
