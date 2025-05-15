#!/usr/bin/bash

termux_download_deb_pac() {

	local PKG_NAME="$1"
	local PKG_DIR="$2"
	local PKG_ARCH="$3"
	local PKG_VERSION="$4"
	local PKG_VERSION_PACMAN="$5"

	local PKG_LABEL
	local PKG_LOCAL_FILE_DIR
	local PKG_LOCAL_FILE_NAME
	local TERMUX_REPO_PACKAGES_UNUSABLE_REASON


	termux_package__get_package_name_and_version_label PKG_LABEL \
		"$PKG_NAME" "$PKG_VERSION" "$PKG_VERSION_PACMAN" "$TERMUX_WITHOUT_DEPVERSION_BINDING" || return $?

	# FIXME: Remove after commit
	# Dependencies should be used from repo only if they are built for
	# same package name.
	# The data.tar.xz extraction by termux_step_get_dependencies would
	# extract files to different prefix than TERMUX_PREFIX and builds
	# would fail when looking for -I$TERMUX_PREFIX/include files.
	#if [ "$TERMUX_REPO_PACKAGE" != "$TERMUX_APP_PACKAGE" ]; then
	#	echo "Ignoring the download of '$PKG_FILE' since repo package name ($TERMUX_REPO_PACKAGE) does not equal app package name ($TERMUX_APP_PACKAGE)"
	#	return 1
	#fi

	# Dependencies should only be used from packages repos if packages
	# hosted there are built for the current package build variables
	# in the 'properties.sh' file.
	# Check the `scripts/repo.sh` file and docs for the below function
	# for more info.
	if ! termux_repository__are_packages_in_packages_repos_usable_for_building \
			TERMUX_REPO_PACKAGES_UNUSABLE_REASON "false"; then
		logger__log 1 "Ignoring download of '$PKG_LABEL' since \
${TERMUX_REPO_PACKAGES_UNUSABLE_REASON:-"due to unknown error."}"
		return 69 # EX__UNAVAILABLE
	fi


	# Download repo metadata files.
	termux_get_repo_files || return $?


	if [[ "$TERMUX_ON_DEVICE_BUILD" == "true" ]]; then
		logger__log 1 "Downloading '$PKG_LABEL' package with '$TERMUX_APP_PACKAGE_MANAGER' package manager"
		case "$TERMUX_APP_PACKAGE_MANAGER" in
			# FIXME: Only return EX__UNAVAILABLE if package or required version is not available.
	# The `apt-cache madison <package_name>` command can be used to
	# get info for all available package versions in the repo channels,
	# regardless of if package is installed. Multiple package versions
	# can exist in the same repo channel and same/different versions
	# can exist in different repo channels.
	# The madison command outputs in the following format for a package.
	# Multiple entries may exist depending on if matched package is
	# found with different versions.
	# The space characters in the `3` `|` sections will vary as field
	# width `setw(10)` is used.
	#
	# ```
	# <package_name> | <package_version> | <repo_url> <repo_distribution>/<repo_component> <arch> Packages
	# ```

			# - https://manpages.debian.org/testing/apt/apt-cache.8.en.html
			# - https://github.com/Debian/apt/blob/2.8.1/cmdline/apt-cache.cc#L1030
			# - https://github.com/Debian/apt/blob/2.8.1/apt-pkg/cacheset.h#L468-L477
			# - https://github.com/Debian/apt/blob/2.8.1/apt-pkg/cacheset.cc#L47
			# - https://github.com/Debian/apt/blob/2.8.1/apt-pkg/cacheset.cc#L248
			# - https://github.com/Debian/apt/blob/2.8.1/apt-pkg/cacheset.cc#L734
			# - https://github.com/Debian/apt/blob/2.8.1/cmdline/apt-cache.cc#L1053-L1054
			# apt-cache madison eza | cut -d '|' -f 2 | tr -d ' ' | grep -qFx "0.19.2"
			"apt")
				apt install -y "${PKG_NAME}$(test "$TERMUX_WITHOUT_DEPVERSION_BINDING" != true && echo "=${PKG_VERSION}")" || \
					return 69 # EX__UNAVAILABLE
			;;
			"pacman")
	# The `pacman -S --search <search_regex>` sync search command can
	# be used to get info for all available package versions in the
	# repo channels, regardless of if package is installed. Only one
	# package version can exist in the same repo channel, but
	# same/different versions can exist in different repo channels.
	# The search command outputs in the following format for a package.
	# Multiple entries may exist depending on if matched package is
	# found in different repo channels with different versions.
	# The ` [installed]` part will only be printed for packages locally
	# installed. The `<package_description>` will be indented with 4
	# spaces.
	# The search command must be passed the package name as a regex
	# with start and end anchors `^<package_name>$` so that exact
	# package name is matched, as pacman will also do a normal text
	# match with `strstr()` against package names in database for the
	# `search_regex` argument passed.
	# The `--color never` argument is passed so that escape sequences
	# for colors are not added.
	# ```
	# <repo_distribution>/<package_name> <package_version> [installed]
	#     <package_description>
	# ```
	# - https://man.archlinux.org/man/pacman.8.en.html#SYNC_OPTIONS_(APPLY_TO_-S)
	# - https://gitlab.archlinux.org/pacman/pacman/-/blob/v6.1.0/src/pacman/pacman.c#L851
	# - https://gitlab.archlinux.org/pacman/pacman/-/blob/v6.1.0/src/pacman/pacman.c#L1283
	# - https://gitlab.archlinux.org/pacman/pacman/-/blob/v6.1.0/src/pacman/sync.c#L944
	# - https://gitlab.archlinux.org/pacman/pacman/-/blob/v6.1.0/src/pacman/sync.c#L325
	# - https://gitlab.archlinux.org/pacman/pacman/-/blob/v6.1.0/src/pacman/package.c#L552
	# - https://gitlab.archlinux.org/pacman/pacman/-/blob/v6.1.0/lib/libalpm/db.c#L478
	# - https://gitlab.archlinux.org/pacman/pacman/-/blob/v6.1.0/src/pacman/package.c#L571-582
	# - https://gitlab.archlinux.org/pacman/pacman/-/blob/v6.1.0/src/pacman/package.c#L503-508
	# - https://gitlab.archlinux.org/pacman/pacman/-/blob/v6.1.0/lib/libalpm/alpm.h#L1296
	# - https://gitlab.archlinux.org/pacman/pacman/-/blob/v6.1.0/src/pacman/conf.c#L86

	# pacman --color never -S --search "^<package_name>$" | grep -E '^<repo_distribution>/<package_name> [^ ].*$' | cut -d ' ' -f 2
	# pacman --color never -S --search "^termux-tools$" | grep -E '^main/termux-tools [^ ].*$' | cut -d ' ' -f 2

	# - https://gitlab.archlinux.org/pacman/pacman/-/blob/v6.1.0/src/pacman/sync.c#L432
	# - https://gitlab.archlinux.org/pacman/pacman/-/blob/v6.1.0/src/pacman/package.c#L266
	# - https://gitlab.archlinux.org/pacman/pacman/-/blob/v6.1.0/src/pacman/util.c#L551
	# - pacman --color never -S --info "main/termux-tools" | grep -E '^Version[ ]+: ([^ ]+)$' | sed -E 's/^Version[ ]+: ([^ ]+)$/\1/g'

				pacman -S "${PKG_NAME}$(test "$TERMUX_WITHOUT_DEPVERSION_BINDING" != true && echo "=${PKG_VERSION_PACMAN}")" --needed --noconfirm || \
					return 69 # EX__UNAVAILABLE
			;;
		esac
	else
		PKG_LOCAL_FILE_DIR="$TERMUX_COMMON_CACHEDIR/$PKG_ARCH/package-files/$PKG_NAME"
		rm -rf "$PKG_LOCAL_FILE_DIR" || return $?
		mkdir -p "$PKG_LOCAL_FILE_DIR" || return $?

		logger__log 1 "Downloading '$PKG_LABEL' package from '$TERMUX_REPO__PACKAGE_MANAGER' packages repo"
		termux_repository__download_package_file PKG_LOCAL_FILE_NAME \
			"$TERMUX_SCRIPTDIR" "$TERMUX_COMMON_CACHEDIR" \
			"$PKG_DIR" "$PKG_ARCH" "$PKG_VERSION" "$PKG_VERSION_PACMAN" \
			"$TERMUX_WITHOUT_DEPVERSION_BINDING" "$PKG_LOCAL_FILE_DIR" \
			"${TERMUX_IS_DISABLED:-}" "${TERMUX_QUIET_BUILD:-}" || return $?

		termux_packaging__extract_rootfs_files_from_package_file \
			"$PKG_NAME" "$PKG_LOCAL_FILE_DIR" "$PKG_LOCAL_FILE_NAME" "$PKG_LOCAL_FILE_DIR" "/" || return $?
	fi

}

# Make script standalone executable as well as sourceable
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
	termux_download_deb_pac "$@"
fi
