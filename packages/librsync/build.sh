TERMUX_PKG_HOMEPAGE=https://github.com/librsync/librsync
TERMUX_PKG_DESCRIPTION="Remote delta-compression library"
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.3.3"
TERMUX_PKG_SRCURL=https://github.com/librsync/librsync/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=1a79a74173fe385bb59e6ff5be80ac33ab654f9fcc7a9beba37d875ecba88a39
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libbz2"
TERMUX_PKG_BUILD_DEPENDS="libpopt"
TERMUX_PKG_BREAKS="librsync-dev"
TERMUX_PKG_REPLACES="librsync-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DPERL_EXECUTABLE=$(command -v perl)"

termux_step_post_get_source() {
        # Do not forget to bump revision of reverse dependencies and rebuild them
        # after SOVERSION is changed.
        local _SOVERSION=2

        local v=$(echo ${TERMUX_PKG_VERSION#*:} | cut -d . -f 1)
        if [ "${v}" != "${_SOVERSION}" ]; then
                termux_error_exit "SOVERSION guard check failed."
        fi
}
