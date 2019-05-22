termux_step_handle_arguments() {
	_show_usage() {
	    echo "Usage: ./build-package.sh [-a ARCH] [-d] [-D] [-f] [-i] [-I] [-q] [-s] [-o DIR] PACKAGE"
	    echo "Build a package by creating a .deb file in the debs/ folder."
	    echo "  -a The architecture to build for: aarch64(default), arm, i686, x86_64 or all."
	    echo "  -d Build with debug symbols."
	    echo "  -D Build a disabled package in disabled-packages/."
	    echo "  -f Force build even if package has already been built."
	    echo "  -i Download and extract dependencies instead of building them."
	    echo "  -I Download and extract dependencies instead of building them, keep existing /data/data/com.termux files."
	    echo "  -q Quiet build."
	    echo "  -s Skip dependency check."
	    echo "  -o Specify deb directory. Default: debs/."
	    exit 1
	}
	while getopts :a:hdDfiIqso: option; do
		case "$option" in
		a) TERMUX_ARCH="$OPTARG";;
		h) _show_usage;;
		d) export TERMUX_DEBUG=true;;
		D) local TERMUX_IS_DISABLED=true;;
		f) TERMUX_FORCE_BUILD=true;;
		i) export TERMUX_INSTALL_DEPS=true;;
		I) export TERMUX_INSTALL_DEPS=true && export TERMUX_NO_CLEAN=true;;
		q) export TERMUX_QUIET_BUILD=true;;
		s) export TERMUX_SKIP_DEPCHECK=true;;
		o) TERMUX_DEBDIR="$(realpath -m $OPTARG)";;
		?) termux_error_exit "./build-package.sh: illegal option -$OPTARG";;
		esac
	done
	shift $((OPTIND-1))

	if [ "$#" -ne 1 ]; then _show_usage; fi
	unset -f _show_usage

	# Handle 'all' arch:
	if [ -n "${TERMUX_ARCH+x}" ] && [ "${TERMUX_ARCH}" = 'all' ]; then
		for arch in 'aarch64' 'arm' 'i686' 'x86_64'; do
			TERMUX_BUILD_IGNORE_LOCK=true ./build-package.sh ${TERMUX_FORCE_BUILD+-f} \
				-a $arch ${TERMUX_INSTALL_DEPS+-i} ${TERMUX_IS_DISABLED+-D} ${TERMUX_DEBUG+-d} \
				${TERMUX_DEBDIR+-o $TERMUX_DEBDIR} "$1"
		done
		exit
	fi

	# Check the package to build:
	TERMUX_PKG_NAME=$(basename "$1")
	export TERMUX_SCRIPTDIR
	TERMUX_SCRIPTDIR=$(cd "$(dirname "$0")"; pwd)
	if [[ $1 == *"/"* ]]; then
		# Path to directory which may be outside this repo:
		if [ ! -d "$1" ]; then termux_error_exit "'$1' seems to be a path but is not a directory"; fi
		export TERMUX_PKG_BUILDER_DIR
		TERMUX_PKG_BUILDER_DIR=$(realpath "$1")
	else
		# Package name:
		if [ -n "${TERMUX_IS_DISABLED=""}" ]; then
			export TERMUX_PKG_BUILDER_DIR=$TERMUX_SCRIPTDIR/disabled-packages/$TERMUX_PKG_NAME
		else
			export TERMUX_PKG_BUILDER_DIR=$TERMUX_SCRIPTDIR/packages/$TERMUX_PKG_NAME
		fi
	fi
	TERMUX_PKG_BUILDER_SCRIPT=$TERMUX_PKG_BUILDER_DIR/build.sh
	if test ! -f "$TERMUX_PKG_BUILDER_SCRIPT"; then
		termux_error_exit "No build.sh script at package dir $TERMUX_PKG_BUILDER_DIR!"
	fi
}
