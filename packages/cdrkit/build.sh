TERMUX_PKG_HOMEPAGE=https://salsa.debian.org/debian/cdrkit
TERMUX_PKG_DESCRIPTION="cdrkit is a command-line toolkit for creating and burning CD/DVD image files."
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@xingguangcuican6666"
TERMUX_PKG_VERSION="1.1.11-5"
TERMUX_PKG_SRCURL="https://salsa.debian.org/debian/cdrkit/-/archive/debian/9%251.1.11-5/cdrkit-debian-9%25$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=cd1781f29f8a98a3364727a242d9f243c695c563bc1cc072c548bb31349ca12f
TERMUX_PKG_DEPENDS="libandroid-glob, libandroid-shmem, libandroid-support, libandroid-utimes, libbz2, libcap, libiconv, zlib"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBITFIELDS_HTOL:STRING=0
-DNET_TRANSPORT:BOOL=OFF
-DTHREADED_CHECKSUMS:BOOL=OFF
-DHAVE_VALLOC:BOOL=OFF
-DHAVE_SETUID:BOOL=OFF
-DHAVE_SETEUID:BOOL=OFF
-DHAVE_SETREUID:BOOL=OFF
"

termux_step_pre_configure() {
	export LDFLAGS="$LDFLAGS -landroid-glob -landroid-utimes"
}
