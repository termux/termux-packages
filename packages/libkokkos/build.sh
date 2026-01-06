TERMUX_PKG_HOMEPAGE=https://github.com/kokkos
TERMUX_PKG_DESCRIPTION="Implements a programming model in C++ for writing performance portable applications"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_LICENSE_FILE="COPYRIGHT.md"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="5.0.1"
TERMUX_PKG_SRCURL=https://github.com/kokkos/kokkos/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=d8d2669870b84c3c58543dd165962385042f7325ba228b2b6f02769187324d01
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libandroid-execinfo, libc++"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_SHARED_LIBS=ON
-DKokkos_ENABLE_LIBDL=OFF
"
TERMUX_PKG_EXCLUDED_ARCHES="arm, i686"

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-execinfo"
}
