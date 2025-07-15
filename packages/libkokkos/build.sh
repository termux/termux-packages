TERMUX_PKG_HOMEPAGE=https://github.com/kokkos
TERMUX_PKG_DESCRIPTION="Implements a programming model in C++ for writing performance portable applications"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_LICENSE_FILE="Copyright.txt"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.6.02"
TERMUX_PKG_SRCURL=https://github.com/kokkos/kokkos/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=a4e6a39f34a0ffec8de0b23959a9866721363b581adb60554263bcfc15a10734
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
