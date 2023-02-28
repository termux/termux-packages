TERMUX_PKG_HOMEPAGE=https://github.com/librsync/librsync
TERMUX_PKG_DESCRIPTION="Remote delta-compression library"
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.3.4"
TERMUX_PKG_SRCURL=https://github.com/librsync/librsync/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=a0dedf9fff66d8e29e7c25d23c1f42beda2089fb4eac1b36e6acd8a29edfbd1f
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
