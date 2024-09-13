TERMUX_PKG_HOMEPAGE=https://github.com/kokkos
TERMUX_PKG_DESCRIPTION="Implements a programming model in C++ for writing performance portable applications"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_LICENSE_FILE="Copyright.txt"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.4.01"
TERMUX_PKG_SRCURL=https://github.com/kokkos/kokkos/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=3f7096d17eaaa4004c7497ac082bf1ae3ff47b5104149e54af021a89414c3682
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libandroid-execinfo, libc++"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_SHARED_LIBS=ON
-DKokkos_ENABLE_LIBDL=OFF
"
TERMUX_PKG_BLACKLISTED_ARCHES="arm, i686"

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-execinfo"
}
