termux_step_setup_variables() {
	: "${TERMUX_ARCH:="aarch64"}" # arm, aarch64, i686 or x86_64.
	: "${TERMUX_OUTPUT_DIR:="${TERMUX_SCRIPTDIR}/output"}"
	: "${TERMUX_DEBUG_BUILD:="false"}"
	: "${TERMUX_FORCE_BUILD:="false"}"
	: "${TERMUX_FORCE_BUILD_DEPENDENCIES:="false"}"
	: "${TERMUX_INSTALL_DEPS:="false"}"
	: "${TERMUX_PKG_MAKE_PROCESSES:="$(nproc)"}"
	: "${TERMUX_PKGS__BUILD__RM_ALL_PKGS_BUILT_MARKER_AND_INSTALL_FILES:="true"}"
	: "${TERMUX_PKGS__BUILD__RM_ALL_PKG_BUILD_DEPENDENT_DIRS:="false"}"
	: "${TERMUX_PKG_API_LEVEL:="24"}"
	: "${TERMUX_CONTINUE_BUILD:="false"}"
	: "${TERMUX_QUIET_BUILD:="false"}"
	: "${TERMUX_WITHOUT_DEPVERSION_BINDING:="false"}"
	: "${TERMUX_SKIP_DEPCHECK:="false"}"
	: "${TERMUX_GLOBAL_LIBRARY:="false"}"
	: "${TERMUX_FIX_CYCLIC_DEPS_WITH_VIRTUAL_PKGS:="false"}"
	: "${TERMUX_TOPDIR:="$HOME/.termux-build"}"
	: "${TERMUX_PACMAN_PACKAGE_COMPRESSION:="xz"}"

	if [ -z "${TERMUX_PACKAGE_FORMAT-}" ]; then
		if [ "$TERMUX_ON_DEVICE_BUILD" = "true" ] && [ -n "${TERMUX_APP_PACKAGE_MANAGER-}" ]; then
			TERMUX_PACKAGE_FORMAT="$([ "${TERMUX_APP_PACKAGE_MANAGER-}" = "apt" ] && echo "debian" || echo "${TERMUX_APP_PACKAGE_MANAGER-}")"
		else
			TERMUX_PACKAGE_FORMAT="debian"
		fi
	fi

	case "${TERMUX_PACKAGE_FORMAT-}" in
		debian) export TERMUX_PACKAGE_MANAGER="apt";;
		pacman) export TERMUX_PACKAGE_MANAGER="pacman";;
		*) termux_error_exit "Unsupported package format \"${TERMUX_PACKAGE_FORMAT-}\". Only 'debian' and 'pacman' formats are supported";;
	esac

	# Default package library base
	if [ -z "${TERMUX_PACKAGE_LIBRARY-}" ]; then
		export TERMUX_PACKAGE_LIBRARY="bionic"
	fi

	if [ "$TERMUX_PACKAGE_LIBRARY" = "glibc" ]; then
		termux_build_props__set_termux_prefix_dir_and_sub_variables "$TERMUX__PREFIX_GLIBC"
		if [ "$TERMUX_ON_DEVICE_BUILD" = "false" ] && [ "$TERMUX_PREFIX" != "$CGCT_DEFAULT_PREFIX" ]; then
			export CGCT_APP_PREFIX="$TERMUX_PREFIX"
		fi
		if ! termux_package__is_package_name_have_glibc_prefix "$TERMUX_PKG_NAME"; then
			TERMUX_PKG_NAME="$(termux_package__add_prefix_glibc_to_package_name "${TERMUX_PKG_NAME}")"
		fi
	fi

	if [ "$TERMUX_ON_DEVICE_BUILD" = "true" ]; then
		# For on-device builds cross-compiling is not supported so we can
		# store information about built packages under $TERMUX_TOPDIR.
		TERMUX_BUILT_PACKAGES_DIRECTORY="$TERMUX_TOPDIR/.built-packages"
		TERMUX_PKGS__BUILD__RM_ALL_PKGS_BUILT_MARKER_AND_INSTALL_FILES="false"

		if [ "$TERMUX_PACKAGE_LIBRARY" = "bionic" ]; then
			# On-device builds without termux-exec are unsupported.
			if [[ ":${LD_PRELOAD:-}:" != ":${TERMUX__PREFIX__LIB_DIR}/libtermux-exec"*".so:" ]]; then
				termux_error_exit "On-device builds without termux-exec are not supported."
			fi
		fi
	else
		TERMUX_BUILT_PACKAGES_DIRECTORY="/data/data/.built-packages"
	fi

	# TERMUX_PKG_MAINTAINER should be explicitly set in build.sh of the package.
	: "${TERMUX_PKG_MAINTAINER:="default"}"

	termux_step_setup_arch_variables
	TERMUX_REAL_ARCH="$TERMUX_ARCH"
	TERMUX_REAL_HOST_PLATFORM="$TERMUX_HOST_PLATFORM"

	if [ "$TERMUX_PACKAGE_LIBRARY" = "bionic" ]; then
		if [ "$TERMUX_ON_DEVICE_BUILD" = "false" ] && [ ! -d "$NDK" ]; then
			termux_error_exit 'NDK not pointing at a directory!'
		fi

		if [ "$TERMUX_ON_DEVICE_BUILD" = "false" ] && ! grep -s -q "Pkg.Revision = $TERMUX_NDK_VERSION_NUM" "$NDK/source.properties"; then
			termux_error_exit "Wrong NDK version - we need $TERMUX_NDK_VERSION"
		fi
	elif [ "$TERMUX_PACKAGE_LIBRARY" = "glibc" ]; then
		if [ "$TERMUX_ON_DEVICE_BUILD" = "true" ]; then
			if [ -n "${LD_PRELOAD-}" ]; then
				unset LD_PRELOAD
			fi
			if [ ! -d "${TERMUX_PREFIX}/bin" ]; then
				termux_error_exit "Glibc components are not installed, run './scripts/setup-termux-glibc.sh'"
			fi
		else
			if [ ! -d "${CGCT_DIR}/${TERMUX_ARCH}/bin" ]; then
				termux_error_exit "The cgct tools were not found, run './scripts/setup-cgct.sh'"
			fi
		fi
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

	# Explicitly export in case the default was set.
	export TERMUX_ARCH=${TERMUX_ARCH}

	if [ "${TERMUX_PACKAGES_OFFLINE-false}" = "true" ]; then
		# In "offline" mode store/pick cache from directory with
		# build.sh script.
		TERMUX_PKG_CACHEDIR=$TERMUX_PKG_BUILDER_DIR/cache
	else
		TERMUX_PKG_CACHEDIR=$TERMUX_TOPDIR/$TERMUX_PKG_NAME/cache
	fi
	TERMUX_CMAKE_BUILD=Ninja # Which cmake generator to use
	TERMUX_PKG_ANTI_BUILD_DEPENDS="" # This cannot be used to "resolve" circular dependencies
	TERMUX_PKG_BREAKS="" # https://www.debian.org/doc/debian-policy/ch-relationships.html#s-binarydeps
	TERMUX_PKG_BUILDDIR=$TERMUX_TOPDIR/$TERMUX_PKG_NAME/build
	TERMUX_PKG_BUILD_DEPENDS=""
	TERMUX_PKG_BUILD_IN_SRC=false
	TERMUX_PKG_BUILD_MULTILIB=false # multilib-compilation (compilation of 32-bit packages for 64-bit devices)
	TERMUX_PKG_BUILD_ONLY_MULTILIB=false # Specifies that the package is compiled only via multilib-compilation. Enabled automatically if multilib-compilation is enabled and the `TERMUX_PKG_EXCLUDED_ARCHES` variable contains `arm` and `i686` values.
	TERMUX_PKG_MULTILIB_BUILDDIR=$TERMUX_TOPDIR/$TERMUX_PKG_NAME/multilib-build # path to the assembled components of the 32-bit package if multilib-compilation is enabled
	TERMUX_PKG_CONFFILES=""
	TERMUX_PKG_CONFLICTS="" # https://www.debian.org/doc/debian-policy/ch-relationships.html#s-conflicts
	TERMUX_PKG_DEPENDS=""
	TERMUX_PKG_DESCRIPTION="FIXME:Add description"
	TERMUX_PKG_DISABLE_GIR=false # termux_setup_gir
	TERMUX_PKG_ESSENTIAL=false
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS=""
	TERMUX_PKG_EXTRA_HOSTBUILD_CONFIGURE_ARGS=""
	TERMUX_PKG_EXTRA_MAKE_ARGS=""
	TERMUX_PKG_EXTRA_UNDEF_SYMBOLS_TO_CHECK="" # space-separated undefined symbols to check in termux_step_massaging
	TERMUX_PKG_FORCE_CMAKE=false # if the package has autotools as well as cmake, then set this to prefer cmake
	TERMUX_PKG_GIT_BRANCH="" # branch defaults to 'v$TERMUX_PKG_VERSION' unless this variable is defined
	TERMUX_PKG_HAS_DEBUG=true # set to false if debug build doesn't exist or doesn't work, for example for python based packages
	TERMUX_PKG_HOMEPAGE=""
	TERMUX_PKG_HOSTBUILD=false # Set if a host build should be done in TERMUX_PKG_HOSTBUILD_DIR:
	TERMUX_PKG_HOSTBUILD_DIR=$TERMUX_TOPDIR/$TERMUX_PKG_NAME/host-build
	TERMUX_PKG_LICENSE_FILE="" # Relative path from $TERMUX_PKG_SRCDIR to LICENSE file. It is installed to $TERMUX_PREFIX/share/$TERMUX_PKG_NAME.
	TERMUX_PKG_MASSAGEDIR=$TERMUX_TOPDIR/$TERMUX_PKG_NAME/massage
	TERMUX_PKG_METAPACKAGE=false
	TERMUX_PKG_NO_ELF_CLEANER=false # set this to true to disable running of termux-elf-cleaner on built binaries
	TERMUX_PKG_NO_REPLACE_GUESS_SCRIPTS=false # if true, do not find and replace config.guess and config.sub in source directory
	TERMUX_PKG_NO_SHEBANG_FIX=false # if true, skip fixing shebang accordingly to TERMUX_PREFIX
	TERMUX_PKG_NO_SHEBANG_FIX_FILES="" # files to be excluded from fixing shebang
	TERMUX_PKG_NO_STRIP=false # set this to true to disable stripping binaries
	TERMUX_PKG_NO_STATICSPLIT=false
	TERMUX_PKG_STATICSPLIT_EXTRA_PATTERNS=""
	TERMUX_PKG_PACKAGEDIR=$TERMUX_TOPDIR/$TERMUX_PKG_NAME/package
	TERMUX_PKG_PLATFORM_INDEPENDENT=false
	TERMUX_PKG_PRE_DEPENDS=""
	TERMUX_PKG_PROVIDES="" #https://www.debian.org/doc/debian-policy/#virtual-packages-provides
	TERMUX_PKG_RECOMMENDS="" # https://www.debian.org/doc/debian-policy/ch-relationships.html#s-binarydeps
	TERMUX_PKG_REPLACES=""
	TERMUX_PKG_REVISION="0" # http://www.debian.org/doc/debian-policy/ch-controlfields.html#s-f-Version
	TERMUX_PKG_RM_AFTER_INSTALL=""
	TERMUX_PKG_SHA256=""
	TERMUX_PKG_SRCDIR=$TERMUX_TOPDIR/$TERMUX_PKG_NAME/src
	TERMUX_PKG_SUGGESTS=""
	TERMUX_PKG_TMPDIR=$TERMUX_TOPDIR/$TERMUX_PKG_NAME/tmp
	TERMUX_PKG_UNDEF_SYMBOLS_FILES="" # maintainer acknowledges these files have undefined symbols will not result in broken packages, eg: all, *.elf, ./path/to/file. "error" to always print results as errors
	TERMUX_PKG_NO_OPENMP_CHECK=false # if true, skip the openmp check
	TERMUX_PKG_SERVICE_SCRIPT=() # Fill with entries like: ("daemon name" 'script to execute'). Script is echoed with -e so can contain \n for multiple lines
	TERMUX_PKG_GROUPS="" # https://wiki.archlinux.org/title/Pacman#Installing_package_groups
	TERMUX_PKG_ON_DEVICE_BUILD_NOT_SUPPORTED=false # if the package does not support compilation on a device, then this package should not be compiled on devices
	TERMUX_PKG_SETUP_PYTHON=false # setting python to compile a package
	TERMUX_PYTHON_VERSION=$(. $TERMUX_SCRIPTDIR/$(test "${TERMUX_PACKAGE_LIBRARY}" = "bionic" && echo "packages" || echo "gpkg")/python/build.sh; echo $_MAJOR_VERSION) # get the latest version of python
	TERMUX_PKG_PYTHON_TARGET_DEPS="" # python modules to be installed via pip3
	TERMUX_PKG_PYTHON_BUILD_DEPS="" # python modules to be installed via build-pip
	TERMUX_PKG_PYTHON_COMMON_DEPS="" # python modules to be installed via pip3 or build-pip
	TERMUX_PYTHON_CROSSENV_PREFIX="$TERMUX_TOPDIR/python${TERMUX_PYTHON_VERSION}-crossenv-prefix-$TERMUX_PACKAGE_LIBRARY-$TERMUX_ARCH" # python modules dependency location (only used in non-devices)
	TERMUX_PYTHON_HOME=$TERMUX__PREFIX__LIB_DIR/python${TERMUX_PYTHON_VERSION} # location of python libraries
	TERMUX_PKG_MESON_NATIVE=false
	TERMUX_PKG_CMAKE_CROSSCOMPILING=true
	TERMUX_PROOT_EXTRA_ENV_VARS="" # Extra environvent variables for proot command in termux_setup_proot
	TERMUX_PKG_ONLY_INSTALLING=false # when a package is set to true and compilation occurs without installing dependencies (that is, dependencies will also be compiled), the package's dependency will be included in the list of dependencies of other packages (that will require this package) instead of including the package in this list. This variable also applies to subpackages of the package, but this can be changed through the `TERMUX_SUBPKG_ONLY_INSTALLING` variable for subpackages (only for algorithms `scripts/buildorder.py`)
	TERMUX_PKG_SEPARATE_SUB_DEPENDS=false # when set to true in a package, subpackage(s) of package will not be added to the dependency of the parent package (only for algorithms `scripts/buildorder.py`)
	TERMUX_PKG_ACCEPT_PKG_IN_DEP=false # allows you to add an initial package as a dependency, if any requested package (and their dependencies) will have a dependency on it (only for algorithms `scripts/buildorder.py`)

	TERMUX_VIRTUAL_PKG=false # if true, the package will be built as a virtual package
	TERMUX_VIRTUAL_PKG_SRC="" # specify a package (path) to virtualize this package (when specifying this variable in a package, it will automatically indicate that the package is virtual)
	TERMUX_VIRTUAL_PKG_INCLUDE="" # list of sources from the package that will be included in the virtual package (by default, all sources will be included; to disable inclusion of sources, set the value to "false")
	TERMUX_VIRTUAL_PKG_ANTI_DEPENDS="" # list of dependencies that will be disabled (can be used to get rid of cyclic dependencies)
	TERMUX_VIRTUAL_PKG_NAME="$TERMUX_PKG_NAME"
	TERMUX_VIRTUAL_PKG_BUILDER_DIR="$TERMUX_PKG_BUILDER_DIR"
	TERMUX_VIRTUAL_PKG_BUILDER_SCRIPT="$TERMUX_PKG_BUILDER_SCRIPT"

	unset CFLAGS CPPFLAGS LDFLAGS CXXFLAGS
	unset TERMUX_MESON_ENABLE_SOVERSION # setenv to enable SOVERSION suffix for shared libs built with Meson
}

# Setting architectural information according to the `TERMUX_ARCH` variable
termux_step_setup_arch_variables() {
	if [ "x86_64" = "$TERMUX_ARCH" ] || [ "aarch64" = "$TERMUX_ARCH" ]; then
		TERMUX_ARCH_BITS=64
	else
		TERMUX_ARCH_BITS=32
	fi

	if [ "$TERMUX_PACKAGE_LIBRARY" = "bionic" ]; then
		TERMUX_HOST_PLATFORM="${TERMUX_ARCH}-linux-android"
	else
		TERMUX_HOST_PLATFORM="${TERMUX_ARCH}-linux-gnu"
	fi
	if [ "$TERMUX_ARCH" = "arm" ]; then
		TERMUX_HOST_PLATFORM="${TERMUX_HOST_PLATFORM}eabi"
		if [ "$TERMUX_PACKAGE_LIBRARY" = "glibc" ]; then
			TERMUX_HOST_PLATFORM="${TERMUX_HOST_PLATFORM}hf"
		fi
	fi
}
