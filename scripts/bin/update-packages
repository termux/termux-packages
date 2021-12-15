#!/usr/bin/env bash
set -e -u
BASEDIR=$(dirname "$(realpath "$0")")

# These variables should be set in environment outside of this script.
# Build updated packages.
: "${BUILD_PACKAGES:=false}"
# Commit changes to Git.
: "${GIT_COMMIT_PACKAGES:=false}"
# Push changes to remote.
: "${GIT_PUSH_PACKAGES:=false}"

if [ -z "${GITHUB_API_TOKEN-}" ]; then
	echo "Error: you need a Github Personal Access Token be set in variable GITHUB_API_TOKEN."
	exit 1
fi

for pkg_dir in "${BASEDIR}"/../../packages/*; do
	if [ -f "${pkg_dir}/build.sh" ]; then
		package=$(basename "$pkg_dir")
	else
		# Fail if detected a non-package directory.
		echo "Error: directory '${pkg_dir}' is not a package."
		exit 1
	fi

	# Extract the package auto-update configuration.
	build_vars=$(
		set +e +u
		. "${BASEDIR}/../../packages/${package}/build.sh" 2>/dev/null
		echo "auto_update_flag=${TERMUX_PKG_AUTO_UPDATE};"
		echo "termux_version=\"${TERMUX_PKG_VERSION}\";"
		echo "srcurl=\"${TERMUX_PKG_SRCURL}\";"
		echo "version_regexp=\"${TERMUX_PKG_AUTO_UPDATE_TAG_REGEXP//\\/\\\\}\";"
	)
	auto_update_flag=""; termux_version=""; srcurl=""; version_regexp="";
	eval "$build_vars"

	# Ignore packages that have auto-update disabled.
	if [ "${auto_update_flag}" != "true" ]; then
		continue
	fi

	# Extract github project from TERMUX_PKG_SRCURL
	project="$(echo "${srcurl}" | grep github.com | cut -d / -f4-5)"
	if [ -z "${project}" ]; then
		echo "Error: package '${package}' doesn't use GitHub archive source URL but has been configured for automatic updates."
		exit 1
	fi

	# Our local version of package.
	termux_epoch="$(echo "$termux_version" | cut -d: -f1)"
	termux_version=$(echo "$termux_version" | cut -d: -f2-)
	if [ "$termux_version" == "$termux_epoch" ]; then
		# No epoch set.
		termux_epoch=""
	else
		termux_epoch+=":"
	fi

	# Get the latest release tag.
	latest_tag=$(curl --silent --location -H "Authorization: token ${GITHUB_API_TOKEN}" "https://api.github.com/repos/${project}/releases/latest" | jq -r .tag_name)

	# If the github api returns error
	if [ -z "$latest_tag" ] || [ "${latest_tag}" = "null" ]; then
		echo "Error: failed to get the latest release tag for '${package}'. GitHub API returned 'null' which indicates that no releases available."
		exit 1
	fi

	# Remove leading 'v' which is common in version tag.
	latest_version=${latest_tag#v}

	# If needed, filter version numbers from tag by using regexp.
	if [ -n "$version_regexp" ]; then
		latest_version=$(grep -oP "$version_regexp" <<< "$latest_version" || true)
	fi
	if [ -z "$latest_version" ]; then
		echo "Error: failed to get latest version for '${package}'. Check whether the TERMUX_PKG_AUTO_UPDATE_TAG_REGEXP='${version_regexp}' is work right with latest_release='${latest_tag}'."
		exit 1
	fi

	# Translate "_" into ".": some packages use underscores to seperate
	# version numbers, but we require them to be separated by dots.
	latest_version=${latest_version//_/.}

	# We have no better choice for comparing versions.
	if [ "$(echo -e "${termux_version}\n${latest_version}" | sort -V | head -n 1)" != "$latest_version" ] ;then
		if [ "$BUILD_PACKAGES" = "false" ]; then
			echo "Package '${package}' needs update to '${latest_version}'."
		else
			echo "Updating '${package}' to '${latest_version}'."
			sed -i "s/^\(TERMUX_PKG_VERSION=\)\(.*\)\$/\1${termux_epoch}${latest_version}/g" "${BASEDIR}/../../packages/${package}/build.sh"
			sed -i "/TERMUX_PKG_REVISION=/d" "${BASEDIR}/../../packages/${package}/build.sh"
			echo n | "${BASEDIR}/../bin/update-checksum" "$package" || {
				echo "Warning: failed to update checksum for '${package}', skipping..."
				git checkout -- "${BASEDIR}/../../packages/${package}"
				git pull --rebase
				continue
			}

			echo "Trying to build package '${package}'."
			if "${BASEDIR}/../run-docker.sh" ./build-package.sh -a aarch64 -I "$package" && \
				"${BASEDIR}/../run-docker.sh" ./build-package.sh -a arm -I "$package"; then
				if [ "$GIT_COMMIT_PACKAGES" = "true" ]; then
					git add "${BASEDIR}/../../packages/${package}"
					git commit -m "$(echo -e "${package}: update to ${latest_version}\n\nThis commit has been automatically submitted by Github Actions.")"
				fi

				if [ "$GIT_PUSH_PACKAGES" = "true" ]; then
					git pull --rebase
					git push
				fi
			else
				echo "Warning: failed to build '${package}'."
				git checkout -- "${BASEDIR}/../../packages/${package}"
			fi
		fi
	fi
done
