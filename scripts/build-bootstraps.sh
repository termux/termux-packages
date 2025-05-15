#!/usr/bin/env bash
# shellcheck disable=SC2039,SC2059

# Title:         build-bootstrap.sh
# Description:   A script to build bootstrap archives for the termux-app
#                from local package sources instead of (deb) package
#                files published in (apt) packages repos like done by
#                `generate-bootstrap.sh`. It allows bootstrap archives
#                to be built for (forked) termux apps without having
#                to publish an (apt) packages repos first.
# Usage:         run "build-bootstrap.sh --help"
version=0.2.0

set -e

export TERMUX_SCRIPTDIR=$(realpath "$(dirname "$(realpath "$0")")/../")
: "${TERMUX_TOPDIR:="$HOME/.termux-build"}"
. "${TERMUX_SCRIPTDIR}"/scripts/properties.sh
. "${TERMUX_SCRIPTDIR}"/scripts/build/termux_step_handle_buildarch.sh

BOOTSTRAP_TMPDIR=$(mktemp -d "${TMPDIR:-/tmp}/bootstrap-tmp.XXXXXXXX")

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

# The package manager that will be installed in bootstrap.
# The default is 'apt'.
TERMUX_PACKAGE_MANAGER="apt"

TERMUX_PACKAGES_REPO_ROOT_DIRECTORY="/home/builder/termux-packages"
TERMUX_PACKAGES_REPO_OUTPUT_DIRECTORY="$TERMUX_PACKAGES_REPO_ROOT_DIRECTORY/output"
TERMUX_BUILT_PACKAGE_FILES_DIRECTORY="$TERMUX_PACKAGES_REPO_OUTPUT_DIRECTORY"
TERMUX_BOOTSTRAP_OUTPUT_DIRECTORY="$TERMUX_PACKAGES_REPO_ROOT_DIRECTORY"

IGNORE_BUILD_SCRIPT_NOT_FOUND_ERROR=true
NO_CLEAN_BEFORE_BUILD=false

# A list of packages to build
declare -a PACKAGES_LIST=()

# The list of packages that should be added to the bootstraps in
# addition to the default packages that are built before the default
# packages.
declare -a PACKAGES_PRE_ADDITIONAL_LIST=()

# The list of packages that should be added to the bootstraps in
# addition to the default packages that are built after the default
# packages.
declare -a PACKAGES_POST_ADDITIONAL_LIST=()

# A list of options to pass to build-package.sh
declare -a BUILD_PACKAGE_OPTIONS=()

# Check for some important utilities that may not be available for
# some reason.
for cmd in ar awk curl date grep gzip find sed tar xargs xz zip; do
	if [ -z "$(command -v $cmd)" ]; then
		echo "[!] Utility '$cmd' is not available in PATH."
		exit 1
	fi
done

# Build deb files for package and its dependencies deb from source for arch
build_package() {

	local return_value

	local package_arch="$1"
	local package_name="$2"

	local build_output

	local build_package_options=("${BUILD_PACKAGE_OPTIONS[@]}")

	# Build package from source
	# stderr will be redirected to stdout and both will be captured into variable and printed on screen
	cd "$TERMUX_PACKAGES_REPO_ROOT_DIRECTORY"
	echo $'\n\n\n'"[*] Starting to build package '$package_name' for arch '$package_arch'..."

	exec 99>&1
	build_output="$("$TERMUX_PACKAGES_REPO_ROOT_DIRECTORY"/build-package.sh "${build_package_options[@]}" -a "$package_arch" "$package_name" 2>&1 | tee >(cat - >&99); exit ${PIPESTATUS[0]})";
	return_value=$?
	echo "[*] Building '$package_name' exited with exit code $return_value"
	exec 99>&-
	if [ $return_value -ne 0 ]; then
		echo "Failed to build package '$package_name' for arch '$package_arch'" 1>&2

		# Dependency packages may not have a build.sh, so we ignore the error.
		# A better way should be implemented to validate if its actually a dependency
		# and not a required package itself, by removing dependencies from PACKAGES array.
		if [[ $IGNORE_BUILD_SCRIPT_NOT_FOUND_ERROR == "true" ]] && [[ "$build_output" == *"Failed to find 'build.sh' file"* ]]; then
			echo "Ignoring error \"Failed to find 'build.sh' file\"" 1>&2
			return 0
		fi
	fi

	return $return_value

}

extract_package_files() {

	local package_arch="$1"

	cd "$TERMUX_BUILT_PACKAGE_FILES_DIRECTORY"

	if [ -z "$(find . -maxdepth 1 -type f \( -name "*_*_${package_arch}.deb" -o -name "*_*_all.deb" \))" ]; then
		echo $'\n\n\n'"No debs found for arch $package_arch"
		return 1
	else
		echo $'\n\n\n'"Deb Files:"
		echo "\""
		find . -name "*.deb"
		echo "\""
	fi

	extract_debs "$@"

	echo $'\n\n\n'"Bootstrap Packages:"
	echo "\""
	find "$BOOTSTRAP_PKGDIR" | sort
	echo "\""

}

# Extract *.deb files to the bootstrap root.
extract_debs() {

	local package_arch="$1"
	shift

	local control_archive
	local data_archive
	local deb_file
	local file
	local package_name
	local package_dependency
	local package_dependencies
	local package_tmpdir
	local token

	for package_name in "$@"; do
		if [ -z "$package_name" ]; then
			continue
		fi

		deb_file="$(find . -maxdepth 1 -type f \( -name "${package_name}_*_${package_arch}.deb" -o -name "${package_name}_*_all.deb" \))"
		if [ -n "$deb_file" ]; then
			if [ "$(echo "$deb_file" | wc -l)" -gt 1 ]; then
				echo "More than one deb file found for package '$package_name'" 1>&2
				return 1
			fi
		else
			echo "No deb file found for package '$package_name'" 1>&2
			return 1
		fi

		# Extract current package
		package_tmpdir="${BOOTSTRAP_PKGDIR}/${package_name}"
		if [ -e "$package_tmpdir" ]; then
			continue
		fi

		mkdir -p "$package_tmpdir"
		rm -rf "$package_tmpdir"/*

		echo "[*] Extracting '$deb_file'..."
		(cd "$package_tmpdir"
			ar x "$TERMUX_BUILT_PACKAGE_FILES_DIRECTORY/$deb_file"

			# data.tar may have extension different from .xz
			if [ -f "./data.tar.xz" ]; then
				data_archive="data.tar.xz"
			elif [ -f "./data.tar.gz" ]; then
				data_archive="data.tar.gz"
			else
				echo "No data.tar.* found in '$deb_file'."
				return 1
			fi

			# Do same for control.tar.
			if [ -f "./control.tar.xz" ]; then
				control_archive="control.tar.xz"
			elif [ -f "./control.tar.gz" ]; then
				control_archive="control.tar.gz"
			else
				echo "No control.tar.* found in '$deb_file'."
				return 1
			fi

			# Extract files.
			tar -tf "$data_archive"
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

		# Extract package dependencies
		package_dependencies=$(
			while read -r token; do
				echo "$token" | cut -d'|' -f1 | sed -E 's@\(.*\)@@'
			done < <(dpkg-deb --show --showformat='${Depends}\n' "$deb_file" | tr ',' '\n')
		)

		if [ -n "$package_dependencies" ]; then
			echo "[*] $package_name dependencies: $(echo "$package_dependencies" | tr '\n' ' ')"
			for package_dependency in $package_dependencies; do
				if [ ! -e "${BOOTSTRAP_PKGDIR}/${package_dependency}" ]; then
					extract_debs "$package_arch" "$package_dependency"
				fi
			done
		fi

	done

}

# Add termux bootstrap second stage files
add_termux_bootstrap_second_stage_files() {

	local package_arch="$1"

	echo $'\n\n\n'"[*] Adding termux bootstrap second stage files..."

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

set_build_bootstrap_traps() {

	#set traps for the build_bootstrap_trap itself
	trap 'build_bootstrap_trap' EXIT
	trap 'build_bootstrap_trap TERM' TERM
	trap 'build_bootstrap_trap INT' INT
	trap 'build_bootstrap_trap HUP' HUP
	trap 'build_bootstrap_trap QUIT' QUIT

	return 0

}


build_bootstrap_killtree() {

	local signal="$1"; local pid="$2"; local cpid
	for cpid in $(pgrep -P "$pid"); do build_bootstrap_killtree "$signal" "$cpid"; done
	[[ "$pid" != "$$" ]] && signal="${signal:=15}"; kill "-$signal" "$pid" 2>/dev/null

}

build_bootstrap_trap() {

	local build_bootstrap_trap_exit_code=$?
	trap - EXIT

	[ -d "$BOOTSTRAP_TMPDIR" ] && rm -rf "$BOOTSTRAP_TMPDIR"

	[ -n "$1" ] && trap - "$1";
	build_bootstrap_killtree "$1" $$;
	exit $build_bootstrap_trap_exit_code

}

show_usage() {

	cat <<'HELP_EOF'

build-bootstraps.sh is a script to build bootstrap archives for the
termux-app from local package sources instead of debs published in
apt repo like done by generate-bootstrap.sh. It allows bootstrap archives
to be easily built for (forked) termux apps without having to publish
an apt repo first.


Usage:
	build-bootstraps.sh [command_options]


Available command_options:
    [ -h  | --help ]          Display this help screen
    [ --android10 ]
                    Build bootstrap archives for Android 10+ for
                    apk packaging system.
    [ -a | --add <packages> ]
                    Additional packages to include into bootstrap archive.
                    Multiple packages should be passed as comma-separated list.
    [ --architectures <architectures> ]
                    Override default list of architectures for which bootstrap
                    archives will be created. Multiple architectures should be
                    passed as comma-separated list.
    [ --allow-disabled-packages ] Allow building packages under
                    'disabled-packages' directory.
    [ --no-build-unneeded-subpackages ]
                   Do not build unneeded subpackages that are not
                   dependencies of their parent package.
    [ --no-clean ] Do not clean build environment and existing output
                   package and bootstrap files before building.
    [ --packages-pre-additional=<packages> ]
                   The comma-separated list of packages that should
                   be added to the bootstraps in addition to
                   the default packages that are built before the
                   default packages.
    [ --packages-post-additional=<packages> ]
                   The comma-separated list of packages that should
                   be added to the bootstraps in addition to
                   the default packages that are built after the
                   default packages.



The package name/prefix that the bootstrap is built for is defined by
TERMUX_APP_PACKAGE in 'scrips/properties.sh'. It defaults to 'com.termux'.
If package name is changed, make sure to run
`./scripts/run-docker.sh ./clean.sh` or pass '-f' to force rebuild of packages.

The `--no-clean` flag should only be passed for testing or if certain
package build is failing and you want to start build again from that
package after applying a fix, instead of building all packages from
the start again. Ideally, the final bootstraps should be created
without the `--no-clean` flag in one go.


Build default bootstraps for all supported archs:
./scripts/run-docker.sh ./scripts/build-bootstraps.sh --no-build-unneeded-subpackages &> build.log

Build default bootstraps for `aarch64` arch only:
./scripts/run-docker.sh ./scripts/build-bootstraps.sh --architectures aarch64 --no-build-unneeded-subpackages &> build.log

Build bootstraps with additionall `openssh` package for `aarch64` arch only:
./scripts/run-docker.sh ./scripts/build-bootstraps.sh --architectures aarch64 --packages-post-additional openssh --no-build-unneeded-subpackages &> build.log

Passing the `--no-build-unneeded-subpackages` is advisable as it will
skip building subpackages that are not needed and so bootstraps will
be compiled much faster. For example, passing it will skip building
the `dpkg-perl` subpackage, which depends on `clang`
(subpackage of `libllvm`), which takes many hours to build. The `dpkg`
package is needed by `apt` package manager, but `dpkg-perl` is not
necessary and does not need to be added to bootstrap.
However, this can cause problems where an important subpackage
which is a dependency of another package gets skipped, like `gpgv`
subpackage dependency of `apt`, and bootstrap build will fail with
the following error if required package is not found:
`No package file found for package '<package_name>'`
This should not occur for default packages, but it can happen if
additional packages are passed with the `--packages-*-additional`
arguments.
To fix this, either do not pass the `--no-build-unneeded-subpackages`
flag so that all packages and their subpackages get built, or
explicitly pass the missing subpackage to `--packages-pre-additional`
and it will get built regardless of whether its a dependency of parent
package or not.
Do not pass the subpackage in `--packages-post-additional` as
otherwise the package will get built twice, first for the parent
package as a dependency, and then as the explicit subpackage passed.
HELP_EOF

echo $'\n'"TERMUX_APP_PACKAGE: \"$TERMUX_APP_PACKAGE\""
echo "TERMUX_PREFIX: \"${TERMUX_PREFIX[*]}\""
echo "TERMUX_ARCHITECTURES: \"${TERMUX_ARCHITECTURES[*]}\""

}

main() {

	local return_value

	local boostrap_build_start_time
	local boostraps_build_start_time
	local elapsed_seconds
	local package_arch
	local package_name

	while (($# > 0)); do
		case "$1" in
			-h|--help)
				show_usage
				return 0
				;;
			--android10)
				BOOTSTRAP_ANDROID10_COMPATIBLE=true
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
					echo "[!] Option '--architectures' requires an argument." 1>&2
					show_usage
					return 1
				fi
				;;
			--allow-disabled-packages)
				BUILD_PACKAGE_OPTIONS+=("-D")
				;;
			--no-build-unneeded-subpackages)
				BUILD_PACKAGE_OPTIONS+=("--no-build-unneeded-subpackages")
			;;
			--no-clean)
				NO_CLEAN_BEFORE_BUILD=true
				;;
			--packages-pre-additional)
				if [ $# -gt 1 ] && [ -n "$2" ] && [[ $2 != -* ]]; then
					for pkg in $(echo "$2" | tr ',' ' '); do
						PACKAGES_PRE_ADDITIONAL_LIST+=("$pkg")
					done
					unset pkg
					shift 1
				else
					echo "[!] Option '--packages-pre-additional' requires an argument." 1>&2
					show_usage
					return 1
				fi
				;;
			--packages-post-additional)
				if [ $# -gt 1 ] && [ -n "$2" ] && [[ $2 != -* ]]; then
					for pkg in $(echo "$2" | tr ',' ' '); do
						PACKAGES_POST_ADDITIONAL_LIST+=("$pkg")
					done
					unset pkg
					shift 1
				else
					echo "[!] Option '--packages-pre-additional' requires an argument." 1>&2
					show_usage
					return 1
				fi
				;;
			*)
				echo "[!] Got unknown option '$1'" 1>&2
				show_usage
				return 1
				;;
		esac
		shift 1
	done

	set_build_bootstrap_traps

	if [[ "$TERMUX_PACKAGE_MANAGER" == *" "* ]] || [[ " ${TERMUX_SUPPORTED_PACKAGE_MANAGERS[*]} " != *" $TERMUX_PACKAGE_MANAGER "* ]]; then
		echo "[!] Invalid package manager '$TERMUX_PACKAGE_MANAGER'" 1>&2
		echo "Supported package managers: '${TERMUX_SUPPORTED_PACKAGE_MANAGERS[*]}'" 1>&2
		exit 1
	fi

	for package_arch in "${TERMUX_ARCHITECTURES[@]}"; do
		if [[ "$package_arch" == *" "* ]] || [[ " ${!TERMUX_SUPPORTED_ARCHITECTURES_TO_ABIS_MAP[*]} " != *" $package_arch "* ]]; then
			echo "[!] Unsupported architecture '$package_arch' in architectures list: '${TERMUX_ARCHITECTURES[*]}'" 1>&2
			echo "Supported architectures: '${!TERMUX_SUPPORTED_ARCHITECTURES_TO_ABIS_MAP[*]}'" 1>&2
			return 1
		fi
	done

	echo "[*] Building bootstraps for archs: ${TERMUX_ARCHITECTURES[*]}"
	boostraps_build_start_time="$(date +%s)"

	if [[ $NO_CLEAN_BEFORE_BUILD != "true" ]]; then
		# The files under TERMUX_BUILT_PACKAGE_FILES_DIRECTORY
		# should be deleted before building for an arch
		# since if the output directory already has older
		# (deb) package files with multiple versions of the same
		# package, an error would be raised. And even if there
		# was a single deb for the package, it may be the wrong
		# version.
		if [ -d "$TERMUX_BUILT_PACKAGE_FILES_DIRECTORY" ]; then
			find "$TERMUX_BUILT_PACKAGE_FILES_DIRECTORY" -maxdepth 1 -type f -delete
		fi

		# Delete any old bootstraps for all architectures.
		if [ -d "$TERMUX_BOOTSTRAP_OUTPUT_DIRECTORY" ]; then
			find "$TERMUX_BOOTSTRAP_OUTPUT_DIRECTORY" -maxdepth 1 -type f \
				\( -name "bootstrap-aarch64.zip" -o -name "bootstrap-arm.zip" -o -name "bootstrap-x86_64.zip" -o -name "bootstrap-i686.zip" \) \
				-delete
		fi
	fi

	mkdir -p "$TERMUX_PACKAGES_REPO_OUTPUT_DIRECTORY"

	for package_arch in "${TERMUX_ARCHITECTURES[@]}"; do
		echo $'\n\n\n\n\n'"[*] Starting to build bootstrap for arch '$package_arch'..."
		boostrap_build_start_time="$(date +%s)"

		TERMUX_ARCH="$package_arch" termux_step_handle_buildarch

		if [[ $NO_CLEAN_BEFORE_BUILD != "true" ]]; then
			# The "-f" flag must never be passed to `build-package.sh`
			# with `BUILD_PACKAGE_OPTIONS` as otherwise if a package
			# in `PACKAGES` list first gets built as a dependency of
			# another package, and then its build is manually
			# started as part of bootstrap packages, then it will
			# get built again, which may also fail or create an
			# inconsistent state for certain packages as prefix
			# wouldn't have been wiped. So all packages are manually
			# cleaned before building bootstrap.

			# Remove `$HOME/.termux-build` and termux prefix.
			"$TERMUX_SCRIPTDIR/clean.sh"
		fi

		BOOTSTRAP_ROOTFS="$BOOTSTRAP_TMPDIR/rootfs-${package_arch}"
		BOOTSTRAP_PKGDIR="$BOOTSTRAP_TMPDIR/packages-${package_arch}"

		# Create initial directories for $TERMUX_PREFIX
		if [[ "$BOOTSTRAP_ANDROID10_COMPATIBLE" == "false" ]]; then
			mkdir -p "${BOOTSTRAP_ROOTFS}/${TERMUX_PREFIX}/etc/apt/apt.conf.d"
			mkdir -p "${BOOTSTRAP_ROOTFS}/${TERMUX_PREFIX}/etc/apt/preferences.d"
			mkdir -p "${BOOTSTRAP_ROOTFS}/${TERMUX_PREFIX}/var/lib/dpkg/info"
			mkdir -p "${BOOTSTRAP_ROOTFS}/${TERMUX_PREFIX}/var/lib/dpkg/triggers"
			mkdir -p "${BOOTSTRAP_ROOTFS}/${TERMUX_PREFIX}/var/lib/dpkg/updates"
			mkdir -p "${BOOTSTRAP_ROOTFS}/${TERMUX_PREFIX}/var/log/apt"
			touch "${BOOTSTRAP_ROOTFS}/${TERMUX_PREFIX}/var/lib/dpkg/available"
			touch "${BOOTSTRAP_ROOTFS}/${TERMUX_PREFIX}/var/lib/dpkg/status"
		fi
		mkdir -p "${BOOTSTRAP_ROOTFS}/${TERMUX_PREFIX}/tmp"



		PACKAGES_LIST=()

		# Prepend `PACKAGES_PRE_ADDITIONAL_LIST` to `PACKAGES_LIST`.
		for package_name in "${PACKAGES_PRE_ADDITIONAL_LIST[@]}"; do
			if [[ " ${PACKAGES_LIST[*]} " != *" $package_name "* ]]; then
				PACKAGES_LIST+=("$package_name")
			fi
		done

		# Package manager.
		if [[ "$BOOTSTRAP_ANDROID10_COMPATIBLE" == "false" ]]; then
			PACKAGES_LIST+=("gpgv")
			PACKAGES_LIST+=("apt")
		fi

		# Core utilities.
		PACKAGES_LIST+=("bash") # Used by `termux-bootstrap-second-stage.sh`.
		PACKAGES_LIST+=("bzip2")
		if [[ "$BOOTSTRAP_ANDROID10_COMPATIBLE" == "false" ]]; then
			PACKAGES_LIST+=("command-not-found")
		else
			PACKAGES_LIST+=("proot")
		fi
		PACKAGES_LIST+=("coreutils")
		PACKAGES_LIST+=("curl")
		PACKAGES_LIST+=("dash")
		PACKAGES_LIST+=("diffutils")
		PACKAGES_LIST+=("findutils")
		PACKAGES_LIST+=("gawk")
		PACKAGES_LIST+=("grep")
		PACKAGES_LIST+=("gzip")
		PACKAGES_LIST+=("less")
		PACKAGES_LIST+=("procps")
		PACKAGES_LIST+=("psmisc")
		PACKAGES_LIST+=("sed")
		PACKAGES_LIST+=("tar")
		PACKAGES_LIST+=("termux-core")
		PACKAGES_LIST+=("termux-exec")
		PACKAGES_LIST+=("termux-keyring")
		PACKAGES_LIST+=("termux-tools")
		PACKAGES_LIST+=("util-linux")
		PACKAGES_LIST+=("xz-utils")

		# Additional.
		PACKAGES_LIST+=("ed")
		PACKAGES_LIST+=("debianutils")
		PACKAGES_LIST+=("dos2unix")
		PACKAGES_LIST+=("inetutils")
		PACKAGES_LIST+=("lsof")
		PACKAGES_LIST+=("nano")
		PACKAGES_LIST+=("net-tools")
		PACKAGES_LIST+=("patch")
		PACKAGES_LIST+=("unzip")

		# Append `PACKAGES_POST_ADDITIONAL_LIST` to `PACKAGES_LIST`.
		for package_name in "${PACKAGES_POST_ADDITIONAL_LIST[@]}"; do
			if [[ " ${PACKAGES_LIST[*]} " != *" $package_name "* ]]; then
				PACKAGES_LIST+=("$package_name")
			fi
		done

		# Build packages.
		for package_name in "${PACKAGES_LIST[@]}"; do
			set +e
			build_package "$package_arch" "$package_name" || return $?
			set -e
		done

		# Extract all package files.
		extract_package_files "$package_arch" "${PACKAGES_LIST[@]}"

		# Add termux bootstrap second stage files
		add_termux_bootstrap_second_stage_files "$package_arch"

		# Create bootstrap archive.
		create_bootstrap_archive "$package_arch"

		elapsed_seconds=$(($(date +%s) - boostrap_build_start_time))
		echo "[*] Building bootstrap for arch '$package_arch' completed in $((elapsed_seconds / 3600 )) hours $(((elapsed_seconds % 3600) / 60)) minutes $((elapsed_seconds % 60)) seconds"
	done

	elapsed_seconds=$(($(date +%s) - boostraps_build_start_time))
	echo "[*] Building bootstraps completed in $((elapsed_seconds / 3600 )) hours $(((elapsed_seconds % 3600) / 60)) minutes $((elapsed_seconds % 60)) seconds"

}

main "$@"
