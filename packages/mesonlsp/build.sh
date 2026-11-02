TERMUX_PKG_HOMEPAGE=https://github.com/JCWasmx86/mesonlsp
TERMUX_PKG_DESCRIPTION="an unofficial, unendorsed language server for meson written in C++"
TERMUX_PKG_LICENSE="GPL-3.0-or-later"
TERMUX_PKG_LICENSE_FILE="COPYING"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=4.1.8
TERMUX_PKG_SRCURL="https://github.com/JCWasmx86/mesonlsp/archive/v$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_DEPENDS="libandroid-execinfo, libarchive, libc++, libcurl, libpkgconf, libuuid"
TERMUX_PKG_SHA256=e1fa0aab7367df83ab09778cb7ee53d45e8e08121a0ea1798f66bd69b76a8334
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dbenchmarks=false
"

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-execinfo"
}
