TERMUX_PKG_HOMEPAGE=https://www.openjpeg.org/
TERMUX_PKG_DESCRIPTION="JPEG 2000 image compression library"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.5.2"
TERMUX_PKG_SRCURL=https://github.com/uclouvain/openjpeg/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=90e3896fed910c376aaf79cdd98bdfdaf98c6472efd8e1debf0a854938cbda6a
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BREAKS="openjpeg-dev"
TERMUX_PKG_REPLACES="openjpeg-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DBUILD_STATIC_LIBS=OFF"
# for fast building packages that depend on openjpeg with cmake

termux_step_post_get_source() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _MAJOR_VERSION=2
	local _SOVERSION=7

	case "$TERMUX_PKG_VERSION" in
		${_MAJOR_VERSION}.*|*:${_MAJOR_VERSION}.* ) ;;
		* ) termux_error_exit "Version guard check failed." ;;
	esac

	local v=$(sed -En 's/^.*set\(OPENJPEG_SOVERSION ([0-9]+).*$/\1/p' \
			CMakeLists.txt)
	if [ "${v}" != "${_SOVERSION}" ]; then
		termux_error_exit "SOVERSION guard check failed."
	fi
}

termux_step_pre_configure() {
	# Certain packages are not safe to build on device because their
	# build.sh script deletes specific files in $TERMUX_PREFIX.
	if $TERMUX_ON_DEVICE_BUILD; then
		termux_error_exit "Package '$TERMUX_PKG_NAME' is not safe for on-device builds."
	fi

	# Force symlinks to be overwritten:
	rm -Rf $TERMUX_PREFIX/lib/libopenjp2.so*
}
