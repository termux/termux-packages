TERMUX_PKG_HOMEPAGE=https://github.com/gflags/gflags
TERMUX_PKG_DESCRIPTION="A C++ library that implements commandline flags processing"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_LICENSE_FILE="COPYING.txt"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.2.2
TERMUX_PKG_REVISION=7
TERMUX_PKG_SRCURL=https://github.com/gflags/gflags/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=34af2f15cf7367513b352bdcd2493ab14ce43692d2dcd9dfc499492966c64dcf
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_BREAKS="gflags-dev"
TERMUX_PKG_REPLACES="gflags-dev"
TERMUX_PKG_FORCE_CMAKE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_SHARED_LIBS=ON
-DBUILD_STATIC_LIBS=ON
-DBUILD_gflags_LIBS=ON
-DINSTALL_HEADERS=ON
"

termux_step_post_make_install() {
	#Any old packages using the library name of libgflags
	ln -sfr "$TERMUX_PREFIX"/lib/pkgconfig/gflags.pc \
		"$TERMUX_PREFIX"/lib/pkgconfig/libgflags.pc
}
