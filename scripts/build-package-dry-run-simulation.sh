#!/bin/sh

# 'exit 1' in subshells will exit this script with a return value of 1,
# but 'exit 0' in subshells will not
set -e -u

TERMUX_SCRIPTDIR=$(cd "$(realpath "$(dirname "$0")")"; cd ..; pwd)
. "$TERMUX_SCRIPTDIR/scripts/properties.sh"
. "$TERMUX_SCRIPTDIR/scripts/build/termux_step_setup_variables.sh"
. "$TERMUX_SCRIPTDIR/scripts/build/termux_error_exit.sh"
TERMUX_ON_DEVICE_BUILD=false
BUILDSCRIPT_NAME="build-package.sh"
TMPDIR=$(mktemp -d 2>/dev/null || mktemp -d -t 'mytmpdir')
NDK="$TMPDIR/dummy-ndk"

# Please keep synchronized with the logic of lines 468-547 of build-package.sh
declare -a PACKAGE_LIST=()
while (($# >= 1)); do
	case "$1" in
		*"/$BUILDSCRIPT_NAME") ;;
		-a)
			if [ $# -lt 2 ]; then
				termux_error_exit "./build-package.sh: option '-a' requires an argument"
			fi
			shift 1
			if [ -z "$1" ]; then
				termux_error_exit "Argument to '-a' should not be empty."
			fi
			export TERMUX_ARCH="$1"
			;;
		-d) export TERMUX_DEBUG_BUILD=true ;;
		-*) ;;
		*) PACKAGE_LIST+=("$1") ;;
	esac
	shift 1
done

# please keep synchronized with the logic of lines 592-656 of build-package.sh
for ((i=0; i<${#PACKAGE_LIST[@]}; i++)); do
	(
		TERMUX_PKG_NAME=$(basename "${PACKAGE_LIST[i]}")
		export TERMUX_PKG_BUILDER_DIR=
		for package_directory in $TERMUX_PACKAGES_DIRECTORIES; do
			if [ -d "${TERMUX_SCRIPTDIR}/${package_directory}/${TERMUX_PKG_NAME}" ]; then
				export TERMUX_PKG_BUILDER_DIR=${TERMUX_SCRIPTDIR}/$package_directory/$TERMUX_PKG_NAME
				break
			fi
		done
		if [ -z "${TERMUX_PKG_BUILDER_DIR}" ]; then
			termux_error_exit "No package $TERMUX_PKG_NAME found in any of the enabled repositories. Are you trying to set up a custom repository?"
		fi
		TERMUX_PKG_BUILDER_SCRIPT=$TERMUX_PKG_BUILDER_DIR/build.sh

		mkdir -p "$NDK"
		echo "Pkg.Revision = $TERMUX_NDK_VERSION_NUM" > "$NDK/source.properties"
		termux_step_setup_variables

		# Please keep synchronized with the logic of lines 2-50 of scripts/build/termux_step_start_build.sh
		source "$TERMUX_PKG_BUILDER_SCRIPT"

		if [ -n "${TERMUX_PKG_EXCLUDED_ARCHES:=""}" ] && [ "$TERMUX_PKG_EXCLUDED_ARCHES" != "${TERMUX_PKG_EXCLUDED_ARCHES/$TERMUX_ARCH/}" ]; then
			echo "Skipping building $TERMUX_PKG_NAME for arch $TERMUX_ARCH"
			exit 0
		fi

		if [ "$TERMUX_DEBUG_BUILD" = "true" ] && [ "$TERMUX_PKG_HAS_DEBUG" = "false" ]; then
			echo "Skipping building debug build for $TERMUX_PKG_NAME"
			exit 0
		fi

		termux_error_exit "Ending dry run simulation (a normal build would have continued)"
	)
done

if [ ${#PACKAGE_LIST[@]} -gt 0 ]; then
	# at least one package name was parsed, but none of them reached "exit 1",
	# so exit with return value 0 to indicate that no packages would have been built
	echo "Ending dry run simulation ($BUILDSCRIPT_NAME would not have built any packages)"
	exit 0
fi

# if this point is reached, assume that a combination of arguments
# that is either invalid or is not implemented in this script
# has been used, and the real build-package.sh
# needs to be run so that its own parser can interpret the arguments
# and display the appropriate error message
termux_error_exit "Ending dry run simulation (unknown arguments, pass to the real $BUILDSCRIPT_NAME for more information)"
