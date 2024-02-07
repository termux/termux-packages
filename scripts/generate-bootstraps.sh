#!/usr/bin/env bash
##
##  Script for generating bootstrap archives.
##

set -e

. $(dirname "$(realpath "$0")")/properties.sh
BOOTSTRAP_TMPDIR=$(mktemp -d "${TMPDIR:-/tmp}/bootstrap-tmp.XXXXXXXX")
trap 'rm -rf $BOOTSTRAP_TMPDIR' EXIT

# By default, bootstrap archives are compatible with Android >=7.0
# and <10.
BOOTSTRAP_ANDROID10_COMPATIBLE=false

# Optional caching of downloaded packages in output directory
# Apt only for now
TERMUX_PACKAGE_DOWNLOAD_CACHE=false
TERMUX_PACKAGE_DOWNLOAD_CACHE_DIR="$PWD/output"

# By default, bootstrap archives will be built for all architectures
# supported by Termux application.
# Override with option '--architectures'.
TERMUX_ARCHITECTURES=("aarch64" "arm" "i686" "x86_64")

# The supported termux package managers.
TERMUX_PACKAGE_MANAGERS=("apt" "pacman")

# The repository base urls mapping for package managers.
declare -A REPO_BASE_URLS=(
	["apt"]="https://packages-cf.termux.dev/apt/termux-main"
	["pacman"]="https://s3.amazonaws.com/termux-pacman.us/main"
)

# The package manager that will be installed in bootstrap.
# The default is 'apt'. Can be changed by using the '--pm' option.
TERMUX_PACKAGE_MANAGER="apt"

# The repository base url for package manager.
# Can be changed by using the '--repository' option.
REPO_BASE_URL="${REPO_BASE_URLS[${TERMUX_PACKAGE_MANAGER}]}"

# A list of non-essential packages. By default it is empty, but can
# be filled with option '--add'.
declare -a ADDITIONAL_PACKAGES

# Check for some important utilities that may not be available for
# some reason.
for cmd in ar awk curl grep gzip find sed tar xargs xz zip; do
	if [ -z "$(command -v $cmd)" ]; then
		echo "[!] Utility '$cmd' is not available in PATH."
		exit 1
	fi
done

# Download package lists from remote repository.
# Actually, there 2 lists can be downloaded: one architecture-independent and
# one for architecture specified as '$1' argument. That depends on repository.
# If repository has been created using "aptly", then architecture-independent
# list is not available.
read_package_list_deb() {
	local architecture
	for architecture in all "$1"; do
		if [ ! -e "${BOOTSTRAP_TMPDIR}/packages.${architecture}" ]; then
			echo "[*] Downloading package list for architecture '${architecture}'..."
			if ! curl --fail --location \
				--output "${BOOTSTRAP_TMPDIR}/packages.${architecture}" \
				"${REPO_BASE_URL}/dists/stable/main/binary-${architecture}/Packages"; then
				if [ "$architecture" = "all" ]; then
					echo "[!] Skipping architecture-independent package list as not available..."
					continue
				fi
			fi
			echo >> "${BOOTSTRAP_TMPDIR}/packages.${architecture}"
		fi

		echo "[*] Reading package list for '${architecture}'..."
		while read -r -d $'\xFF' package; do
			if [ -n "$package" ]; then
				local package_name
				package_name=$(echo "$package" | grep -i "^Package:" | awk '{ print $2 }')

				if [ -z "${PACKAGE_METADATA["$package_name"]}" ]; then
					PACKAGE_METADATA["$package_name"]="$package"
				else
					local prev_package_ver cur_package_ver
					cur_package_ver=$(echo "$package" | grep -i "^Version:" | awk '{ print $2 }')
					prev_package_ver=$(echo "${PACKAGE_METADATA["$package_name"]}" | grep -i "^Version:" | awk '{ print $2 }')

					# If package has multiple versions, make sure that our metadata
					# contains the latest one.
					if [ "$(echo -e "${prev_package_ver}\n${cur_package_ver}" | sort -rV | head -n1)" = "${cur_package_ver}" ]; then
						PACKAGE_METADATA["$package_name"]="$package"
					fi
				fi
			fi
		done < <(sed -e "s/^$/\xFF/g" "${BOOTSTRAP_TMPDIR}/packages.${architecture}")
	done
}

read_package_list_pac() {
	if [ ! -e "${BOOTSTRAP_TMPDIR}/main_${1}.db" ]; then
		echo "[*] Downloading package list for architecture '${1}'..."
		curl --fail --location \
			--output "${BOOTSTRAP_TMPDIR}/main_${1}.db" \
			"${REPO_BASE_URL}/${1}/main.db"
	fi

	echo "[*] Reading package list for '${1}'..."
	mkdir -p "${BOOTSTRAP_TMPDIR}/packages"
	tar -xf "${BOOTSTRAP_TMPDIR}/main_${1}.db" -C "${BOOTSTRAP_TMPDIR}/packages"
	local packages_name=($(grep -h -A 1 "%NAME%" "${BOOTSTRAP_TMPDIR}"/packages/*/desc | sed 's/%NAME%//g; s/--//g'))
	local packages_filename=($(grep -h -A 1 "%FILENAME%" "${BOOTSTRAP_TMPDIR}"/packages/*/desc | sed 's/%FILENAME%//g; s/--//g'))
	for i in $(seq 0 $((${#packages_name[@]}-1))); do
		PACKAGE_METADATA["${packages_name[$i]}"]="${1}/${packages_filename[$i]}"
	done
}

# Download specified package, its depenencies and then extract *.deb or *.pkg.tar.xz files to
# the bootstrap root.
pull_package() {
	local package_name=$1
	local package_tmpdir="${BOOTSTRAP_PKGDIR}/${package_name}"
	mkdir -p "$package_tmpdir"

	if [ "$TERMUX_PACKAGE_MANAGER" = apt ]; then
		local package_url package_file
		package_url="$REPO_BASE_URL/$(echo "${PACKAGE_METADATA[${package_name}]}" | grep -i "^Filename:" | awk '{ print $2 }')"
		package_file=$(echo "$package_url" | sed -e 's|\(.*\)\/\(.*\).deb$|\2.deb|')
		if [ "${package_url}" = "$REPO_BASE_URL" ] || [ "${package_url}" = "${REPO_BASE_URL}/" ]; then
			echo "[!] Failed to determine URL for package '$package_name'."
			exit 1
		fi

		local package_dependencies
		package_dependencies=$(
			while read -r token; do
				echo "$token" | cut -d'|' -f1 | sed -E 's@\(.*\)@@'
			done < <(echo "${PACKAGE_METADATA[${package_name}]}" | grep -i "^Depends:" | sed -E 's@^[Dd]epends:@@' | tr ',' '\n')
		)

		# Recursively handle dependencies.
		if [ -n "$package_dependencies" ]; then
			local dep
			for dep in $package_dependencies; do
				if [ ! -e "${BOOTSTRAP_PKGDIR}/${dep}" ]; then
					pull_package "$dep"
				fi
			done
			unset dep
		fi

		if [ "$TERMUX_PACKAGE_DOWNLOAD_CACHE" = true ]; then
			# since each generate-bootstraps.sh run will have different package_tmpdir
			# we dont have to check existence of both files and even so prioritise the cached copy
			# also use symbolic link to save space and I/O
			echo "[*] CACHE: Checking for cached copy of '$package_file' for package '$package_name'..."
			if [ -e "$TERMUX_PACKAGE_DOWNLOAD_CACHE_DIR/$package_file" ]; then
				echo "[*] CACHE: Found cached copy '$package_file'! Symlinking..."
				rm -f "$package_tmpdir/package.deb"
				ln -fs "$TERMUX_PACKAGE_DOWNLOAD_CACHE_DIR/$package_file" "$package_tmpdir/package.deb"
			else
				echo "[*] CACHE: Cached copy of '$package_file' not found. Skipping..."
			fi
		fi

		if [ ! -e "$package_tmpdir/package.deb" ]; then
			echo "[*] Downloading '$package_name'..."
			curl --fail --location --output "$package_tmpdir/package.deb" "$package_url"

			if [ "$TERMUX_PACKAGE_DOWNLOAD_CACHE" = true ]; then
				echo "[*] CACHE: Storing '$package_name' package.deb at '$TERMUX_PACKAGE_DOWNLOAD_CACHE_DIR/$package_file'..."
				cp -f "$package_tmpdir/package.deb" "$TERMUX_PACKAGE_DOWNLOAD_CACHE_DIR/$package_file"
			fi
		fi

		if [ -e "$package_tmpdir/package.deb" ]; then
			echo "[*] Extracting '$package_name'..."
			(cd "$package_tmpdir"
				ar x package.deb

				# data.tar may have extension different from .xz
				if [ -f "./data.tar.xz" ]; then
					data_archive="data.tar.xz"
				elif [ -f "./data.tar.gz" ]; then
					data_archive="data.tar.gz"
				else
					echo "No data.tar.* found in '$package_name'."
					exit 1
				fi

				# Do same for control.tar.
				if [ -f "./control.tar.xz" ]; then
					control_archive="control.tar.xz"
				elif [ -f "./control.tar.gz" ]; then
					control_archive="control.tar.gz"
				else
					echo "No control.tar.* found in '$package_name'."
					exit 1
				fi

				# Extract files.
				tar xf "$data_archive" -C "$BOOTSTRAP_ROOTFS"

				if ! ${BOOTSTRAP_ANDROID10_COMPATIBLE}; then
					# Register extracted files.
					tar tf "$data_archive" | sed -E -e 's@^\./@/@' -e 's@^/$@/.@' -e 's@^([^./])@/\1@' > "${BOOTSTRAP_ROOTFS}/${TERMUX_PREFIX}/var/lib/dpkg/info/${package_name}.list"

					# Generate checksums (md5).
					tar xf "$data_archive"
					find data -type f -print0 | xargs -0 -r md5sum | sed 's@^\.$@@g' > "${BOOTSTRAP_ROOTFS}/${TERMUX_PREFIX}/var/lib/dpkg/info/${package_name}.md5sums"

					# Extract metadata.
					tar xf "$control_archive"
					{
						cat control
						echo "Status: install ok installed"
						echo
					} >> "${BOOTSTRAP_ROOTFS}/${TERMUX_PREFIX}/var/lib/dpkg/status"

					# Additional data: conffiles & scripts
					for file in conffiles postinst postrm preinst prerm; do
						if [ -f "${PWD}/${file}" ]; then
							cp "$file" "${BOOTSTRAP_ROOTFS}/${TERMUX_PREFIX}/var/lib/dpkg/info/${package_name}.${file}"
						fi
					done
				fi
			)
		fi
	else
		local package_desc=$(grep -l $(echo ${PACKAGE_METADATA[${package_name}]} | awk -F "/" '{printf $2}') "${BOOTSTRAP_TMPDIR}"/packages/${package_name}*/desc | head -1)
		local package_dependencies
		local i=0
		package_dependencies=$(
			while [[ -n $(grep -A ${i} %DEPENDS% ${package_desc} | tail -1) ]]; do
				i=$((${i}+1))
				echo $(grep -A ${i} %DEPENDS% ${package_desc} | tail -1 | sed 's/</ /g; s/>/ /g; s/=/ /g' | awk '{printf $1}')
			done
		)

		if [ -n "$package_dependencies" ]; then
			local dep
			for dep in $package_dependencies; do
				if [ ! -e "${BOOTSTRAP_PKGDIR}/${dep}" ]; then
					pull_package "$dep"
				fi
			done
			unset dep
		fi

		if [ ! -e "$package_tmpdir/package.pkg.tar.xz" ]; then
			echo "[*] Downloading '$package_name'..."
			curl --fail --location --output "$package_tmpdir/package.pkg.tar.xz" "${REPO_BASE_URL}/${PACKAGE_METADATA[${package_name}]}"

			echo "[*] Extracting '$package_name'..."
			(cd "$package_tmpdir"
				tar xJf package.pkg.tar.xz
				if [ -d ./data ]; then
					cp -r ./data "$BOOTSTRAP_ROOTFS"
				fi
				local metadata_package_sp=(${PACKAGE_METADATA[${package_name}]//// })
				if [ $(echo "${metadata_package_sp[1]}" | grep "any.") ]; then
					local local_dir_sp=(${metadata_package_sp[1]//-any/ })
				else
					local local_dir_sp=(${metadata_package_sp[1]//-${metadata_package_sp[0]}/ })
				fi
				if [ $(echo "${package_name}" | grep "+") ]; then
					local package_name_in_host="${package_name//+/0}"
					local_dir_sp[0]="${local_dir_sp[0]//${package_name_in_host}/${package_name}}"
				fi
				mkdir -p "${BOOTSTRAP_ROOTFS}/${TERMUX_PREFIX}/var/lib/pacman/local/${local_dir_sp[0]}"
				cp -r .MTREE "${BOOTSTRAP_ROOTFS}/${TERMUX_PREFIX}/var/lib/pacman/local/${local_dir_sp[0]}/mtree"
				cp -r "${package_desc}" "${BOOTSTRAP_ROOTFS}/${TERMUX_PREFIX}/var/lib/pacman/local/${local_dir_sp[0]}/desc"
				if [ -f .INSTALL ]; then
					cp -r .INSTALL "${BOOTSTRAP_ROOTFS}/${TERMUX_PREFIX}/var/lib/pacman/local/${local_dir_sp[0]}/install"
				fi
				{
					echo "%FILES%"
					if [ -d ./data ]; then
						find data
					fi
				} >> "${BOOTSTRAP_ROOTFS}/${TERMUX_PREFIX}/var/lib/pacman/local/${local_dir_sp[0]}/files"
			)
		fi
	fi
}

# Final stage: generate bootstrap archive and place it to current
# working directory.
# Information about symlinks is stored in file SYMLINKS.txt.
create_bootstrap_archive() {
	echo "[*] Creating 'bootstrap-${1}.zip'..."
	(cd "${BOOTSTRAP_ROOTFS}/${TERMUX_PREFIX}"
		# Do not store symlinks in bootstrap archive.
		# Instead, put all information to SYMLINKS.txt
		while read -r -d '' link; do
			echo "$(readlink "$link")←${link}" >> SYMLINKS.txt
			rm -f "$link"
		done < <(find . -type l -print0)

		zip -r9 "${BOOTSTRAP_TMPDIR}/bootstrap-${1}.zip" ./*
	)

	mv -f "${BOOTSTRAP_TMPDIR}/bootstrap-${1}.zip" ./
	echo "[*] Finished successfully (${1})."
}

show_usage() {
	echo
	echo "Usage: generate-bootstraps.sh [options]"
	echo
	echo "Generate bootstrap archives for Termux application."
	echo
	echo "Options:"
	echo
	echo " -h, --help                  Show this help."
	echo
	echo " --android10                 Generate bootstrap archives for Android 10."
	echo
	echo " -a, --add PKG_LIST          Specify one or more additional packages"
	echo "                             to include into bootstrap archive."
	echo "                             Multiple packages should be passed as"
	echo "                             comma-separated list."
	echo
	echo " -c, --cache [DIR]           Enable caching. Downloaded package files will be"
	echo "                             stored at output directory unless specified another"
	echo "                             path. The files can be reused at later runs."
	echo "                             This option is disabled by default and for apt only."
	echo
	echo " --pm MANAGER                Set up a package manager in bootstrap."
	echo "                             It can only be pacman or apt (the default is apt)."
	echo
	echo " --architectures ARCH_LIST   Override default list of architectures"
	echo "                             for which bootstrap archives will be"
	echo "                             created."
	echo "                             Multiple architectures should be passed"
	echo "                             as comma-separated list."
	echo
	echo " -r, --repository URL        Specify URL for APT repository from"
	echo "                             which packages will be downloaded."
	echo "                             This must be passed after '--pm' option."
	echo
	echo "Architectures: ${TERMUX_ARCHITECTURES[*]}"
	echo "Repository Base Url: ${REPO_BASE_URL}"
	echo "Prefix: ${TERMUX_PREFIX}"
	echo "Package manager: ${TERMUX_PACKAGE_MANAGER}"
	echo
}

while (($# > 0)); do
	case "$1" in
		-h|--help)
			show_usage
			exit 0
			;;
		--android10)
			BOOTSTRAP_ANDROID10_COMPATIBLE=true
			;;
		-a|--add)
			if [ $# -gt 1 ] && [ -n "$2" ] && [[ $2 != -* ]]; then
				for pkg in $(echo "$2" | tr ',' ' '); do
					ADDITIONAL_PACKAGES+=("$pkg")
				done
				unset pkg
				shift 1
			else
				echo "[!] Option '--add' requires an argument."
				show_usage
				exit 1
			fi
			;;
		--pm)
			if [ $# -gt 1 ] && [ -n "$2" ] && [[ $2 != -* ]]; then
				TERMUX_PACKAGE_MANAGER="$2"
				REPO_BASE_URL="${REPO_BASE_URLS[${TERMUX_PACKAGE_MANAGER}]}"
				shift 1
			else
				echo "[!] Option '--pm' requires an argument." >&2
				show_usage
				exit 1
			fi
			;;
		--architectures)
			if [ $# -gt 1 ] && [ -n "$2" ] && [[ $2 != -* ]]; then
				TERMUX_ARCHITECTURES=()
				for arch in $(echo "$2" | tr ',' ' '); do
					TERMUX_ARCHITECTURES+=("$arch")
				done
				unset arch
				shift 1
			else
				echo "[!] Option '--architectures' requires an argument."
				show_usage
				exit 1
			fi
			;;
		-r|--repository)
			if [ $# -gt 1 ] && [ -n "$2" ] && [[ $2 != -* ]]; then
				REPO_BASE_URL="$2"
				shift 1
			else
				echo "[!] Option '--repository' requires an argument."
				show_usage
				exit 1
			fi
			;;
		-c|--cache)
			if [ $# -gt 1 ] && [ -n "$2" ] && [[ $2 != -* ]]; then
				TERMUX_PACKAGE_DOWNLOAD_CACHE_DIR="$2"
				shift 1
			fi
			TERMUX_PACKAGE_DOWNLOAD_CACHE=true
			;;
		*)
			echo "[!] Got unknown option '$1'"
			show_usage
			exit 1
			;;
	esac
	shift 1
done

if [[ "$TERMUX_PACKAGE_MANAGER" == *" "* ]] || [[ " ${TERMUX_PACKAGE_MANAGERS[*]} " != *" $TERMUX_PACKAGE_MANAGER "* ]]; then
	echo "[!] Invalid package manager '$TERMUX_PACKAGE_MANAGER'" >&2
	echo "Supported package managers: '${TERMUX_PACKAGE_MANAGERS[*]}'" >&2
	exit 1
fi

if [ -z "$REPO_BASE_URL" ]; then
	echo "[!] The repository base url is not set." >&2
	exit 1
fi

if [ "$TERMUX_PACKAGE_DOWNLOAD_CACHE" = true ]; then
	if [ "$TERMUX_PACKAGE_MANAGER" != apt ]; then
		echo "[!] Option '--cache' does not support '$TERMUX_PACKAGE_MANAGER' yet." >&2
		exit 1
	fi
	echo "[*] CACHE: Caching enabled. Cached packages will be stored and reused."
	echo "[*] CACHE: Cache directory     = $TERMUX_PACKAGE_DOWNLOAD_CACHE_DIR"
	echo "[*] CACHE: Temporary directory = $BOOTSTRAP_TMPDIR"
	mkdir -p "$TERMUX_PACKAGE_DOWNLOAD_CACHE_DIR"
	if [ ! -d "$TERMUX_PACKAGE_DOWNLOAD_CACHE_DIR" ]; then
		echo "[!] CACHE: Failed to create cache directory '$TERMUX_PACKAGE_DOWNLOAD_CACHE_DIR'." >&2
		exit 1
	fi
fi

for package_arch in "${TERMUX_ARCHITECTURES[@]}"; do
	BOOTSTRAP_ROOTFS="$BOOTSTRAP_TMPDIR/rootfs-${package_arch}"
	BOOTSTRAP_PKGDIR="$BOOTSTRAP_TMPDIR/packages-${package_arch}"

	# Create initial directories for $TERMUX_PREFIX
	if ! ${BOOTSTRAP_ANDROID10_COMPATIBLE}; then
		if [ "$TERMUX_PACKAGE_MANAGER" = apt ]; then
			mkdir -p "${BOOTSTRAP_ROOTFS}/${TERMUX_PREFIX}/etc/apt/apt.conf.d"
			mkdir -p "${BOOTSTRAP_ROOTFS}/${TERMUX_PREFIX}/etc/apt/preferences.d"
			mkdir -p "${BOOTSTRAP_ROOTFS}/${TERMUX_PREFIX}/var/lib/dpkg/info"
			mkdir -p "${BOOTSTRAP_ROOTFS}/${TERMUX_PREFIX}/var/lib/dpkg/triggers"
			mkdir -p "${BOOTSTRAP_ROOTFS}/${TERMUX_PREFIX}/var/lib/dpkg/updates"
			mkdir -p "${BOOTSTRAP_ROOTFS}/${TERMUX_PREFIX}/var/log/apt"
			touch "${BOOTSTRAP_ROOTFS}/${TERMUX_PREFIX}/var/lib/dpkg/available"
			touch "${BOOTSTRAP_ROOTFS}/${TERMUX_PREFIX}/var/lib/dpkg/status"
		else
			mkdir -p "${BOOTSTRAP_ROOTFS}/${TERMUX_PREFIX}/var/lib/pacman/sync"
			mkdir -p "${BOOTSTRAP_ROOTFS}/${TERMUX_PREFIX}/var/lib/pacman/local"
			echo "9" >> "${BOOTSTRAP_ROOTFS}/${TERMUX_PREFIX}/var/lib/pacman/local/ALPM_DB_VERSION"
			mkdir -p "${BOOTSTRAP_ROOTFS}/${TERMUX_PREFIX}/var/cache/pacman/pkg"
			mkdir -p "${BOOTSTRAP_ROOTFS}/${TERMUX_PREFIX}/var/log"
		fi
	fi
	mkdir -p "${BOOTSTRAP_ROOTFS}/${TERMUX_PREFIX}/tmp"

	# Read package metadata.
	unset PACKAGE_METADATA
	declare -A PACKAGE_METADATA
	if [ "$TERMUX_PACKAGE_MANAGER" = apt ]; then
		read_package_list_deb "$package_arch"
	else
		read_package_list_pac "$package_arch"
	fi

	# Package manager.
	if ! ${BOOTSTRAP_ANDROID10_COMPATIBLE}; then
		pull_package ${TERMUX_PACKAGE_MANAGER}
	fi

	# Core utilities.
	pull_package bash
	pull_package bzip2
	if ! ${BOOTSTRAP_ANDROID10_COMPATIBLE}; then
		pull_package command-not-found
	else
		pull_package proot
	fi
	pull_package coreutils
	pull_package curl
	pull_package dash
	pull_package diffutils
	pull_package findutils
	pull_package gawk
	pull_package grep
	pull_package gzip
	pull_package less
	pull_package procps
	pull_package psmisc
	pull_package sed
	pull_package tar
	pull_package termux-exec
	pull_package termux-keyring
	pull_package termux-tools
	pull_package util-linux
	pull_package xz-utils

	# Additional.
	pull_package ed
	if [ "$TERMUX_PACKAGE_MANAGER" = apt ]; then
		pull_package debianutils
	fi
	pull_package dos2unix
	pull_package inetutils
	pull_package lsof
	pull_package nano
	pull_package net-tools
	pull_package patch
	pull_package unzip

	# Handle additional packages.
	for add_pkg in "${ADDITIONAL_PACKAGES[@]}"; do
		pull_package "$add_pkg"
	done
	unset add_pkg

	# Create bootstrap archive.
	create_bootstrap_archive "$package_arch"
done
