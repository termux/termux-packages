#!/bin/bash

set -e -u

# This script is in '$TERMUX_SCRIPTDIR/scripts/bin/'.
TERMUX_SCRIPTDIR=$(cd "$(realpath "$(dirname "$0")")"; cd ../..; pwd)
DRY_RUN_SCRIPT_NAME=$(basename "$0")
BUILDSCRIPT_NAME="build-package.sh"
TERMUX_ARCH="aarch64"
TERMUX_DEBUG_BUILD="false"
TERMUX_PACKAGES_DIRECTORIES="
packages
root-packages
x11-packages
"

# Please keep synchronized with the logic of lines 468-547 of 'build-package.sh'.
declare -a PACKAGE_LIST=()
while (($# >= 1)); do
	case "$1" in
		*"/$BUILDSCRIPT_NAME") ;;
		-a)
			if [ $# -lt 2 ]; then
				echo "$DRY_RUN_SCRIPT_NAME: Option '-a' requires an argument"
				exit 1
			fi
			shift 1
			if [ -z "$1" ]; then
				echo "$DRY_RUN_SCRIPT_NAME: Argument to '-a' should not be empty."
				exit 1
			fi
			TERMUX_ARCH="$1"
			;;
		-d) TERMUX_DEBUG_BUILD="true" ;;
		-*) ;;
		*) PACKAGE_LIST+=("$1") ;;
	esac
	shift 1
done

# Please keep synchronized with the logic of lines 592-656 of 'build-package.sh'.
for ((i=0; i<${#PACKAGE_LIST[@]}; i++)); do
	TERMUX_PKG_NAME=$(basename "${PACKAGE_LIST[i]}")
	TERMUX_PKG_BUILDER_DIR=
	for package_directory in $TERMUX_PACKAGES_DIRECTORIES; do
		if [ -d "${TERMUX_SCRIPTDIR}/${package_directory}/${TERMUX_PKG_NAME}" ]; then
			TERMUX_PKG_BUILDER_DIR="${TERMUX_SCRIPTDIR}/$package_directory/$TERMUX_PKG_NAME"
			break
		fi
	done
	if [ -z "${TERMUX_PKG_BUILDER_DIR}" ]; then
		echo "$DRY_RUN_SCRIPT_NAME: No package $TERMUX_PKG_NAME found in any of the enabled repositories. Are you trying to set up a custom repository?"
		exit 1
	fi
	TERMUX_PKG_BUILDER_SCRIPT="$TERMUX_PKG_BUILDER_DIR/build.sh"

	# Please keep synchronized with the logic of lines 2-50 of 'scripts/build/termux_step_start_build.sh'.
	if [ "${TERMUX_ARCH}" != "all" ] && \
		grep -qE "^TERMUX_PKG_EXCLUDED_ARCHES=.*${TERMUX_ARCH}" "$TERMUX_PKG_BUILDER_SCRIPT"; then
		echo "$DRY_RUN_SCRIPT_NAME: Skipping building $TERMUX_PKG_NAME for arch $TERMUX_ARCH"
		continue
	fi

	if [ "${TERMUX_DEBUG_BUILD}" = "true" ] && \
		grep -qE "^TERMUX_PKG_HAS_DEBUG=.*false" "$TERMUX_PKG_BUILDER_SCRIPT"; then
		echo "$DRY_RUN_SCRIPT_NAME: Skipping building debug build for $TERMUX_PKG_NAME"
		continue
	fi

	echo "$DRY_RUN_SCRIPT_NAME: Ending dry run simulation ($BUILDSCRIPT_NAME would have continued building $TERMUX_PKG_NAME)"
	exit 0
done

if [ ${#PACKAGE_LIST[@]} -gt 0 ]; then
	# At least one package name was parsed, but none of them reached "exit 0",
	# so exit with return value 85 (EX_C__NOOP) to indicate that no packages would have been built.
	echo "$DRY_RUN_SCRIPT_NAME: Ending dry run simulation ($BUILDSCRIPT_NAME would not have built any packages)"
	exit 85 # EX_C__NOOP
fi

# If this point is reached, assume that a combination of arguments
# that is either invalid or is not implemented in this script
# has been used, and that the real 'build-package.sh'
# needs to be run so that its own parser can interpret the arguments
# and display the appropriate message.
echo "$DRY_RUN_SCRIPT_NAME: Ending dry run simulation (unknown arguments, pass to the real $BUILDSCRIPT_NAME for more information)"
exit 0
