termux_step_setup_variables() {
	: "${TERMUX_MAKE_PROCESSES:="$(nproc)"}"
	: "${TERMUX_TOPDIR:="$HOME/.termux-build"}"
	: "${TERMUX_ARCH:="aarch64"}" # arm, aarch64, i686 or x86_64.
	: "${TERMUX_DEBUG:="false"}"
	: "${TERMUX_PKG_API_LEVEL:="24"}"
	: "${TERMUX_NO_CLEAN:="false"}"
	: "${TERMUX_QUIET_BUILD:="false"}"
	: "${TERMUX_DEBDIR:="${TERMUX_SCRIPTDIR}/debs"}"
	: "${TERMUX_SKIP_DEPCHECK:="false"}"
	: "${TERMUX_INSTALL_DEPS:="false"}"
	: "${TERMUX_FORCE_BUILD:="false"}"
	: "${TERMUX_PACKAGES_DIRECTORIES:="packages"}"

	if [ "$TERMUX_ON_DEVICE_BUILD" = "true" ]; then
		# For on-device builds cross-compiling is not supported so we can
		# store information about built packages under $TERMUX_TOPDIR.
		TERMUX_BUILT_PACKAGES_DIRECTORY="$TERMUX_TOPDIR/.built-packages"
		TERMUX_NO_CLEAN="true"

		# On-device builds without termux-exec are unsupported.
		if ! grep -q "${TERMUX_PREFIX}/lib/libtermux-exec.so" <<< "${LD_PRELOAD-x}"; then
			termux_error_exit "On-device builds without termux-exec are not supported."
		fi
	else
		TERMUX_BUILT_PACKAGES_DIRECTORY="/data/data/.built-packages"
	fi

	# TERMUX_PKG_MAINTAINER should be explicitly set in build.sh of the package.
	: "${TERMUX_PKG_MAINTAINER:="default"}"

	TERMUX_REPO_URL=(
		https://dl.bintray.com/termux/termux-packages-24
		https://dl.bintray.com/grimler/game-packages-24
		https://dl.bintray.com/grimler/science-packages-24
		https://dl.bintray.com/grimler/termux-root-packages-24
		https://dl.bintray.com/xeffyr/unstable-packages
		https://dl.bintray.com/xeffyr/x11-packages
	)

	TERMUX_REPO_DISTRIBUTION=(
		stable
		games
		science
		root
		unstable
		x11
	)

	TERMUX_REPO_COMPONENT=(
		main
		stable
		stable
		stable
		main
		main
	)

	if [ "x86_64" = "$TERMUX_ARCH" ] || [ "aarch64" = "$TERMUX_ARCH" ]; then
		TERMUX_ARCH_BITS=64
	else
		TERMUX_ARCH_BITS=32
	fi

	TERMUX_HOST_PLATFORM="${TERMUX_ARCH}-linux-android"
	if [ "$TERMUX_ARCH" = "arm" ]; then TERMUX_HOST_PLATFORM="${TERMUX_HOST_PLATFORM}eabi"; fi

	if [ "$TERMUX_ON_DEVICE_BUILD" = "false" ] && [ ! -d "$NDK" ]; then
		termux_error_exit 'NDK not pointing at a directory!'
	fi

	if [ "$TERMUX_ON_DEVICE_BUILD" = "false" ] && ! grep -s -q "Pkg.Revision = $TERMUX_NDK_VERSION_NUM" "$NDK/source.properties"; then
		termux_error_exit "Wrong NDK version - we need $TERMUX_NDK_VERSION"
	fi

	# The build tuple that may be given to --build configure flag:
	TERMUX_BUILD_TUPLE=$(sh "$TERMUX_SCRIPTDIR/scripts/config.guess")

	# We do not put all of build-tools/$TERMUX_ANDROID_BUILD_TOOLS_VERSION/ into PATH
	# to avoid stuff like arm-linux-androideabi-ld there to conflict with ones from
	# the standalone toolchain.
	TERMUX_D8=$ANDROID_HOME/build-tools/$TERMUX_ANDROID_BUILD_TOOLS_VERSION/d8

	TERMUX_COMMON_CACHEDIR="$TERMUX_TOPDIR/_cache"
	TERMUX_ELF_CLEANER=$TERMUX_COMMON_CACHEDIR/termux-elf-cleaner

	export prefix=${TERMUX_PREFIX}
	export PREFIX=${TERMUX_PREFIX}

	if [ "${TERMUX_PACKAGES_OFFLINE-false}" = "true" ]; then
		# In "offline" mode store/pick cache from directory with
		# build.sh script.
		TERMUX_PKG_CACHEDIR=$TERMUX_PKG_BUILDER_DIR/cache
	else
		TERMUX_PKG_CACHEDIR=$TERMUX_TOPDIR/$TERMUX_PKG_NAME/cache
	fi
	TERMUX_PKG_BUILDDIR=$TERMUX_TOPDIR/$TERMUX_PKG_NAME/build
	TERMUX_PKG_MASSAGEDIR=$TERMUX_TOPDIR/$TERMUX_PKG_NAME/massage
	TERMUX_PKG_PACKAGEDIR=$TERMUX_TOPDIR/$TERMUX_PKG_NAME/package
	TERMUX_PKG_SRCDIR=$TERMUX_TOPDIR/$TERMUX_PKG_NAME/src
	TERMUX_PKG_SHA256=""
	TERMUX_PKG_GIT_BRANCH="" # branch defaults to 'v$TERMUX_PKG_VERSION' unless this variable is defined
	TERMUX_PKG_TMPDIR=$TERMUX_TOPDIR/$TERMUX_PKG_NAME/tmp
	TERMUX_PKG_HOSTBUILD_DIR=$TERMUX_TOPDIR/$TERMUX_PKG_NAME/host-build
	TERMUX_PKG_PLATFORM_INDEPENDENT=false
	TERMUX_PKG_NO_STATICSPLIT=false
	TERMUX_PKG_REVISION="0" # http://www.debian.org/doc/debian-policy/ch-controlfields.html#s-f-Version
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS=""
	TERMUX_PKG_EXTRA_HOSTBUILD_CONFIGURE_ARGS=""
	TERMUX_PKG_EXTRA_MAKE_ARGS=""
	TERMUX_PKG_BUILD_IN_SRC=false
	TERMUX_PKG_RM_AFTER_INSTALL=""
	TERMUX_PKG_BREAKS="" # https://www.debian.org/doc/debian-policy/ch-relationships.html#s-binarydeps
	TERMUX_PKG_PRE_DEPENDS=""
	TERMUX_PKG_DEPENDS=""
	TERMUX_PKG_BUILD_DEPENDS=""
	TERMUX_PKG_HOMEPAGE=""
	TERMUX_PKG_DESCRIPTION="FIXME:Add description"
	TERMUX_PKG_LICENSE_FILE="" # Relative path from $TERMUX_PKG_SRCDIR to LICENSE file. It is installed to $TERMUX_PREFIX/share/$TERMUX_PKG_NAME.
	TERMUX_PKG_ESSENTIAL=false
	TERMUX_PKG_CONFLICTS="" # https://www.debian.org/doc/debian-policy/ch-relationships.html#s-conflicts
	TERMUX_PKG_RECOMMENDS="" # https://www.debian.org/doc/debian-policy/ch-relationships.html#s-binarydeps
	TERMUX_PKG_SUGGESTS=""
	TERMUX_PKG_REPLACES=""
	TERMUX_PKG_PROVIDES="" #https://www.debian.org/doc/debian-policy/#virtual-packages-provides
        TERMUX_PKG_SERVICE_SCRIPT=() # Fill with entries like: ("daemon name" 'script to execute'). Script is echoed with -e so can contain \n for multiple lines
	TERMUX_PKG_CONFFILES=""
	# Set if a host build should be done in TERMUX_PKG_HOSTBUILD_DIR:
	TERMUX_PKG_HOSTBUILD=false
	TERMUX_PKG_FORCE_CMAKE=false # if the package has autotools as well as cmake, then set this to prefer cmake
	TERMUX_CMAKE_BUILD=Ninja # Which cmake generator to use
	TERMUX_PKG_HAS_DEBUG=true # set to false if debug build doesn't exist or doesn't work, for example for python based packages
	TERMUX_PKG_METAPACKAGE=false
	TERMUX_PKG_QUICK_REBUILD=false # set this temporarily when iterating on a large package and you don't want the source and build directories wiped every time you make a mistake
	TERMUX_PKG_NO_ELF_CLEANER=false # set this to true to disable running of termux-elf-cleaner on built binaries

	unset CFLAGS CPPFLAGS LDFLAGS CXXFLAGS
}
