TERMUX_PKG_HOMEPAGE=https://github.com/kokkos
TERMUX_PKG_DESCRIPTION="Implements a programming model in C++ for writing performance portable applications"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_LICENSE_FILE="Copyright.txt"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.7.00
TERMUX_PKG_SRCURL=https://github.com/kokkos/kokkos/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=62e3f9f51c798998f6493ed36463f66e49723966286ef70a9dcba329b8443040
TERMUX_PKG_DEPENDS="libandroid-execinfo, libc++"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_SHARED_LIBS=ON
-DKokkos_ENABLE_LIBDL=OFF
"
TERMUX_PKG_BLACKLISTED_ARCHES="arm, i686"

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-execinfo"
}
