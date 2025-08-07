#!/usr/bin/env bash
##
##  Script for generating bootstrap archives.
##

set -e

export TERMUX_SCRIPTDIR=$(realpath "$(dirname "$(realpath "$0")")/../")
. $(dirname "$(realpath "$0")")/properties.sh
BOOTSTRAP_TMPDIR=$(mktemp -d "${TMPDIR:-/tmp}/bootstrap-tmp.XXXXXXXX")
trap 'rm -rf $BOOTSTRAP_TMPDIR' EXIT

# By default, bootstrap archives are compatible with Android >=7.0
# and <10.
BOOTSTRAP_ANDROID10_COMPATIBLE=false

# By default, bootstrap archives will be built for all architectures
# supported by Termux application.
# Override with option '--architectures'.
declare -A TERMUX_SUPPORTED_ARCHITECTURES_TO_ABIS_MAP=(
	["aarch64"]="arm64-v8a"
	["arm"]="armeabi-v7a"
	["x86_64"]="x86_64"
	["i686"]="x86"
)

TERMUX_ARCHITECTURES=("aarch64" "arm" "x86_64" "i686")

# The supported termux package managers.
TERMUX_SUPPORTED_PACKAGE_MANAGERS=("apt" "pacman")

# The repository base urls mapping for package managers.
declare -A REPO_BASE_URLS=(
	["apt"]="https://packages-cf.termux.dev/apt/termux-main"
	["pacman"]="https://service.termux-pacman.dev/main"
)

# The package manager that will be installed in bootstrap.
# The default is 'apt'. Can be changed by using the '--pm' option.
TERMUX_PACKAGE_MANAGER="apt"

TERMUX_PACKAGES_REPO_ROOT_DIRECTORY="$TERMUX_SCRIPTDIR"
TERMUX_BOOTSTRAP_OUTPUT_DIRECTORY="$TERMUX_PACKAGES_REPO_ROOT_DIRECTORY"

NO_CLEAN_BEFORE_BUILD=false

# The repository base url for package manager.
# Can be changed by using the '--repository' option.
REPO_BASE_URL="${REPO_BASE_URLS[${TERMUX_PACKAGE_MANAGER}]}"

# A list of non-essential packages. By default it is empty, but can
# be filled with option '--add'.
declare -a ADDITIONAL_PACKAGES_LIST

# Check for some important utilities that may not be available for
# some reason.
for cmd in ar awk curl date grep gzip find sed tar xargs xz zip jq; do
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

	local package_arch
	local package_name
	local prev_package_ver
	local cur_package_ver

	for package_arch in all "$1"; do
		if [ ! -e "${BOOTSTRAP_TMPDIR}/packages.${package_arch}" ]; then
			echo "[*] Downloading package list for arch '${package_arch}'..."
			if ! curl --fail --location \
				--output "${BOOTSTRAP_TMPDIR}/packages.${package_arch}" \
				"${REPO_BASE_URL}/dists/stable/main/binary-${package_arch}/Packages"; then
				if [ "$package_arch" = "all" ]; then
					echo "[!] Skipping arch-independent package list as not available..."
					continue
				fi
			fi
			echo >> "${BOOTSTRAP_TMPDIR}/packages.${package_arch}"
		fi

		echo "[*] Reading package list for '${package_arch}'..."
		while read -r -d $'\xFF' package; do
			if [ -n "$package" ]; then
				package_name=$(echo "$package" | grep -i "^Package:" | awk '{ print $2 }')

				if [ -z "${PACKAGE_METADATA["$package_name"]}" ]; then
					PACKAGE_METADATA["$package_name"]="$package"
				else
					cur_package_ver=$(echo "$package" | grep -i "^Version:" | awk '{ print $2 }')
					prev_package_ver=$(echo "${PACKAGE_METADATA["$package_name"]}" | grep -i "^Version:" | awk '{ print $2 }')

					# If package has multiple versions, make sure that our metadata
					# contains the latest one.
					if [ "$(echo -e "${prev_package_ver}\n${cur_package_ver}" | sort -rV | head -n1)" = "${cur_package_ver}" ]; then
						PACKAGE_METADATA["$package_name"]="$package"
					fi
				fi
			fi
		done < <(sed -e "s/^$/\xFF/g" "${BOOTSTRAP_TMPDIR}/packages.${package_arch}")
	done

}

download_db_packages_pac() {

	local package_arch="$1"

	if [ ! -e "${PATH_DB_PACKAGES}" ]; then
		echo "[*] Downloading package list for arch '${package_arch}'..."
		curl --fail --location \
			--output "${PATH_DB_PACKAGES}" \
			"${REPO_BASE_URL}/${package_arch}/main.json"
	fi

}

read_db_packages_pac() {

	jq -r '."'${package_name}'"."'${1}'" | if type == "array" then .[] else . end' "${PATH_DB_PACKAGES}"

}

print_desc_package_pac() {

	echo -e "%${1}%\n${2}\n"

}

# Download specified package, its dependencies and then extract *.deb or *.pkg.tar.xz files to
# the bootstrap root.
pull_package() {

	local package_name=$1

	local package_dependencies
	local package_dependency
	local package_desc_keys
	local package_dir_basename
	local package_filename
	local package_url

	local package_tmpdir="${BOOTSTRAP_PKGDIR}/${package_name}"

	mkdir -p "$package_tmpdir"

	if [ ${TERMUX_PACKAGE_MANAGER} = "apt" ]; then
		package_url="$REPO_BASE_URL/$(echo "${PACKAGE_METADATA[${package_name}]}" | grep -i "^Filename:" | awk '{ print $2 }')"
		if [ "${package_url}" = "$REPO_BASE_URL" ] || [ "${package_url}" = "${REPO_BASE_URL}/" ]; then
			echo "[!] Failed to determine URL for package '$package_name'."
			exit 1
		fi

		package_dependencies=$(
			while read -r token; do
				echo "$token" | cut -d'|' -f1 | sed -E 's@\(.*\)@@'
			done < <(echo "${PACKAGE_METADATA[${package_name}]}" | grep -i "^Depends:" | sed -E 's@^[Dd]epends:@@' | tr ',' '\n')
		)

		# Recursively handle dependencies.
		if [ -n "$package_dependencies" ]; then
			for package_dependency in $package_dependencies; do
				if [ ! -e "${BOOTSTRAP_PKGDIR}/${package_dependency}" ]; then
					pull_package "$package_dependency"
				fi
			done
		fi

		if [ ! -e "$package_tmpdir/package.deb" ]; then
			echo "[*] Downloading '$package_name'..."
			curl --fail --location --output "$package_tmpdir/package.deb" "$package_url"

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

				if [[ "$BOOTSTRAP_ANDROID10_COMPATIBLE" == "false" ]]; then
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
		package_dependencies=$(read_db_packages_pac "DEPENDS" | sed 's/<.*$//g; s/>.*$//g; s/=.*$//g')

		if [ "$package_dependencies" != "null" ]; then
			for package_dependency in $package_dependencies; do
				if [ ! -e "${BOOTSTRAP_PKGDIR}/${package_dependency}" ]; then
					pull_package "$package_dependency"
				fi
			done
		fi

		if [ ! -e "$package_tmpdir/package.pkg.tar.xz" ]; then
			echo "[*] Downloading '$package_name'..."
			package_filename=$(read_db_packages_pac "FILENAME")
			curl --fail --location --output "$package_tmpdir/package.pkg.tar.xz" "${REPO_BASE_URL}/${package_arch}/${package_filename}"

			echo "[*] Extracting '$package_name'..."
			(cd "$package_tmpdir"
				package_dir_basename="${package_name}-$(read_db_packages_pac VERSION)"
				mkdir -p "${BOOTSTRAP_ROOTFS}/${TERMUX_PREFIX}/var/lib/pacman/local/${package_dir_basename}"
				{
					echo "%FILES%"
					tar xvf package.pkg.tar.xz -C "$BOOTSTRAP_ROOTFS" .INSTALL .MTREE data 2> /dev/null | grep '^data/' || true
				} >> "${BOOTSTRAP_ROOTFS}/${TERMUX_PREFIX}/var/lib/pacman/local/${package_dir_basename}/files"
				mv "${BOOTSTRAP_ROOTFS}/.MTREE" "${BOOTSTRAP_ROOTFS}/${TERMUX_PREFIX}/var/lib/pacman/local/${package_dir_basename}/mtree"
				if [ -f "${BOOTSTRAP_ROOTFS}/.INSTALL" ]; then
					mv "${BOOTSTRAP_ROOTFS}/.INSTALL" "${BOOTSTRAP_ROOTFS}/${TERMUX_PREFIX}/var/lib/pacman/local/${package_dir_basename}/install"
				fi
				{
					package_desc_keys="VERSION BASE DESC URL ARCH BUILDDATE PACKAGER ISIZE GROUPS LICENSE REPLACES DEPENDS OPTDEPENDS CONFLICTS PROVIDES"
					for i in "NAME ${package_name}" \
						"INSTALLDATE $(date +%s)" \
						"VALIDATION $(test $(read_db_packages_pac PGPSIG) != 'null' && echo 'pgp' || echo 'sha256')"; do
						print_desc_package_pac ${i}
					done
					jq -r -j '."'${package_name}'" | to_entries | .[] | select(.key | contains('$(sed 's/^/"/; s/ /","/g; s/$/"/' <<< ${package_desc_keys})')) | "%",(if .key == "ISIZE" then "SIZE" else .key end),"%\n",.value,"\n\n" | if type == "array" then (.| join("\n")) else . end' \
						"${PATH_DB_PACKAGES}"
				} >> "${BOOTSTRAP_ROOTFS}/${TERMUX_PREFIX}/var/lib/pacman/local/${package_dir_basename}/desc"
			)
		fi
	fi

}

# Add termux bootstrap second stage files
add_termux_bootstrap_second_stage_files() {

	local package_arch="$1"

	echo "[*] Adding termux bootstrap second stage files..."

	mkdir -p "${BOOTSTRAP_ROOTFS}/${TERMUX_BOOTSTRAP__BOOTSTRAP_SECOND_STAGE_DIR}"
	sed -e "s|@TERMUX_PREFIX@|${TERMUX_PREFIX}|g" \
		-e "s|@TERMUX_BOOTSTRAP__BOOTSTRAP_SECOND_STAGE_DIR@|${TERMUX_BOOTSTRAP__BOOTSTRAP_SECOND_STAGE_DIR}|g" \
		-e "s|@TERMUX_BOOTSTRAP__BOOTSTRAP_SECOND_STAGE_ENTRY_POINT_SUBFILE@|${TERMUX_BOOTSTRAP__BOOTSTRAP_SECOND_STAGE_ENTRY_POINT_SUBFILE}|g" \
		-e "s|@TERMUX_PACKAGE_MANAGER@|${TERMUX_PACKAGE_MANAGER}|g" \
		-e "s|@TERMUX_PACKAGE_ARCH@|${package_arch}|g" \
		-e "s|@TERMUX_APP__NAME@|${TERMUX_APP__NAME}|g" \
		-e "s|@TERMUX_ENV__S_TERMUX@|${TERMUX_ENV__S_TERMUX}|g" \
		"$TERMUX_SCRIPTDIR/scripts/bootstrap/$TERMUX_BOOTSTRAP__BOOTSTRAP_SECOND_STAGE_ENTRY_POINT_SUBFILE" \
		> "${BOOTSTRAP_ROOTFS}/${TERMUX_BOOTSTRAP__BOOTSTRAP_SECOND_STAGE_DIR}/$TERMUX_BOOTSTRAP__BOOTSTRAP_SECOND_STAGE_ENTRY_POINT_SUBFILE"
	chmod 700 "${BOOTSTRAP_ROOTFS}/${TERMUX_BOOTSTRAP__BOOTSTRAP_SECOND_STAGE_DIR}/$TERMUX_BOOTSTRAP__BOOTSTRAP_SECOND_STAGE_ENTRY_POINT_SUBFILE"

	# TODO: Remove it when Termux app supports `pacman` bootstraps installation.
	sed -e "s|@TERMUX_PREFIX@|${TERMUX_PREFIX}|g" \
		-e "s|@TERMUX__PREFIX__PROFILE_D_DIR@|${TERMUX__PREFIX__PROFILE_D_DIR}|g" \
		-e "s|@TERMUX_BOOTSTRAP__BOOTSTRAP_SECOND_STAGE_DIR@|${TERMUX_BOOTSTRAP__BOOTSTRAP_SECOND_STAGE_DIR}|g" \
		-e "s|@TERMUX_BOOTSTRAP__BOOTSTRAP_SECOND_STAGE_ENTRY_POINT_SUBFILE@|${TERMUX_BOOTSTRAP__BOOTSTRAP_SECOND_STAGE_ENTRY_POINT_SUBFILE}|g" \
		"$TERMUX_SCRIPTDIR/scripts/bootstrap/01-termux-bootstrap-second-stage-fallback.sh" \
		> "${BOOTSTRAP_ROOTFS}/${TERMUX__PREFIX__PROFILE_D_DIR}/01-termux-bootstrap-second-stage-fallback.sh"
	chmod 600 "${BOOTSTRAP_ROOTFS}/${TERMUX__PREFIX__PROFILE_D_DIR}/01-termux-bootstrap-second-stage-fallback.sh"

}

# Final stage: generate bootstrap archive and place it to current
# working directory.
# Information about symlinks is stored in file SYMLINKS.txt.
create_bootstrap_archive() {

	local bootstrap_arch="$1"

	local bootstrap_filename="bootstrap-$bootstrap_arch.zip"

	mkdir -p "$TERMUX_BOOTSTRAP_OUTPUT_DIRECTORY"
	rm -f "$TERMUX_BOOTSTRAP_OUTPUT_DIRECTORY/$bootstrap_filename"

	echo $'\n\n\n'"[*] Creating '$bootstrap_filename'..."
	(cd "${BOOTSTRAP_ROOTFS}/${TERMUX_PREFIX}"
		# Do not store symlinks in bootstrap archive.
		# Instead, put all information to SYMLINKS.txt
		while read -r -d '' link; do
			echo "$(readlink "$link")←${link}" >> SYMLINKS.txt
			rm -f "$link"
		done < <(find . -type l -print0)

		zip -r9 "${BOOTSTRAP_TMPDIR}/$bootstrap_filename" ./*
	)

	mv -f "${BOOTSTRAP_TMPDIR}/$bootstrap_filename" "$TERMUX_BOOTSTRAP_OUTPUT_DIRECTORY/"

	echo "[*] Finished successfully ($bootstrap_filename)."

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
  	echo " --no-clean                  Do not clean existing bootstrap files before building."
	echo "Architectures: ${TERMUX_ARCHITECTURES[*]}"
	echo "Repository Base Url: ${REPO_BASE_URL}"
	echo "Prefix: ${TERMUX_PREFIX}"
		echo "Package manager: ${TERMUX_PACKAGE_MANAGER}"
	echo

}

main() {

	local boostrap_build_start_time
	local boostraps_build_start_time
	local elapsed_seconds
	local package_arch
	local package_name

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
						ADDITIONAL_PACKAGES_LIST+=("$pkg")
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
					echo "[!] Option '--pm' requires an argument." 1>&2
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
			--no-clean)
				NO_CLEAN_BEFORE_BUILD=true
				;;
			*)
				echo "[!] Got unknown option '$1'"
				show_usage
				exit 1
				;;
		esac
		shift 1
	done

	if [[ "$TERMUX_PACKAGE_MANAGER" == *" "* ]] || [[ " ${TERMUX_SUPPORTED_PACKAGE_MANAGERS[*]} " != *" $TERMUX_PACKAGE_MANAGER "* ]]; then
		echo "[!] Invalid package manager '$TERMUX_PACKAGE_MANAGER'" 1>&2
		echo "Supported package managers: '${TERMUX_SUPPORTED_PACKAGE_MANAGERS[*]}'" 1>&2
		exit 1
	fi

	if [ -z "$REPO_BASE_URL" ]; then
		echo "[!] The repository base url is not set." 1>&2
		exit 1
	fi

	for package_arch in "${TERMUX_ARCHITECTURES[@]}"; do
		if [[ "$package_arch" == *" "* ]] || [[ " ${!TERMUX_SUPPORTED_ARCHITECTURES_TO_ABIS_MAP[*]} " != *" $package_arch "* ]]; then
			echo "[!] Unsupported architecture '$package_arch' in architectures list: '${TERMUX_ARCHITECTURES[*]}'" 1>&2
			echo "Supported architectures: '${!TERMUX_SUPPORTED_ARCHITECTURES_TO_ABIS_MAP[*]}'" 1>&2
			return 1
		fi
	done


	echo "[*] Generating bootstraps for archs: ${TERMUX_ARCHITECTURES[*]}"
	boostraps_build_start_time="$(date +%s)"

	if [[ $NO_CLEAN_BEFORE_BUILD != "true" ]]; then
		# Delete any old bootstraps for all architectures.
		if [ -d "$TERMUX_BOOTSTRAP_OUTPUT_DIRECTORY" ]; then
			find "$TERMUX_BOOTSTRAP_OUTPUT_DIRECTORY" -maxdepth 1 -type f \
				\( -name "bootstrap-aarch64.zip" -o -name "bootstrap-arm.zip" -o -name "bootstrap-x86_64.zip" -o -name "bootstrap-i686.zip" \) \
				-delete
		fi
	fi

	for package_arch in "${TERMUX_ARCHITECTURES[@]}"; do
		echo $'\n\n\n\n\n'"[*] Starting to generate bootstrap for arch '$package_arch'..."
		boostrap_build_start_time="$(date +%s)"

		PATH_DB_PACKAGES="$BOOTSTRAP_TMPDIR/main_${package_arch}.json"
		BOOTSTRAP_ROOTFS="$BOOTSTRAP_TMPDIR/rootfs-${package_arch}"
		BOOTSTRAP_PKGDIR="$BOOTSTRAP_TMPDIR/packages-${package_arch}"

		# Create initial directories for $TERMUX_PREFIX
		if [[ "$BOOTSTRAP_ANDROID10_COMPATIBLE" == "false" ]]; then
			if [ ${TERMUX_PACKAGE_MANAGER} = "apt" ]; then
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
		if [ ${TERMUX_PACKAGE_MANAGER} = "apt" ]; then
			read_package_list_deb "$package_arch"
		else
			download_db_packages_pac "$package_arch"
		fi

		# Package manager.
		if [[ "$BOOTSTRAP_ANDROID10_COMPATIBLE" == "false" ]]; then
			pull_package "${TERMUX_PACKAGE_MANAGER}"
		fi

		# Core utilities.
		pull_package bash # Used by `termux-bootstrap-second-stage.sh`
		pull_package bzip2
		if [[ "$BOOTSTRAP_ANDROID10_COMPATIBLE" == "false" ]]; then
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
		pull_package termux-core
		pull_package termux-exec
		pull_package termux-keyring
		pull_package termux-tools
		pull_package util-linux
		pull_package xz-utils

		# Additional.
		pull_package ed
		if [ ${TERMUX_PACKAGE_MANAGER} = "apt" ]; then
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
		for package_name in "${ADDITIONAL_PACKAGES_LIST[@]}"; do
			pull_package "$package_name"
		done

		# Add termux bootstrap second stage files
		add_termux_bootstrap_second_stage_files "$package_arch"

		# Create bootstrap archive.
		create_bootstrap_archive "$package_arch"

		elapsed_seconds=$(($(date +%s) - boostrap_build_start_time))
		echo "[*] Generating bootstrap for arch '$package_arch' completed in $((elapsed_seconds / 3600 )) hours $(((elapsed_seconds % 3600) / 60)) minutes $((elapsed_seconds % 60)) seconds"
	done

	elapsed_seconds=$(($(date +%s) - boostraps_build_start_time))
	echo "[*] Generating bootstraps completed in $((elapsed_seconds / 3600 )) hours $(((elapsed_seconds % 3600) / 60)) minutes $((elapsed_seconds % 60)) seconds"

}

main "$@"
