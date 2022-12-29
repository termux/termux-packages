TERMUX_PKG_HOMEPAGE="https://www.openblas.net"
TERMUX_PKG_DESCRIPTION="An optimized BLAS library based on GotoBLAS2 1.13 BSD"
TERMUX_PKG_GROUPS="science"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.3.21"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL="https://github.com/xianyi/OpenBLAS/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=f36ba3d7a60e7c8bcc54cd9aaa9b1223dd42eaf02c811791c37e8ca707c241ca
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_FORCE_CMAKE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS='
-DBUILD_SHARED_LIBS=ON
-DBUILD_STATIC_LIBS=OFF
-DC_LAPACK=ON
'

termux_step_post_get_source() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION=0

	local v=$(echo ${TERMUX_PKG_VERSION#*:} | cut -d . -f 1)
	if [ "${v}" != "${_SOVERSION}" ]; then
		termux_error_exit "SOVERSION guard check failed."
	fi
}

termux_step_pre_configure() {
	if [ "$TERMUX_ARCH" = "x86_64" ] || [ "$TERMUX_ARCH" = "i686" ]; then
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+='-DTARGET=CORE2'
	fi
}
