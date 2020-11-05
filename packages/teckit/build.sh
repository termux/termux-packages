TERMUX_PKG_HOMEPAGE=https://scripts.sil.org/teckitdownloads
TERMUX_PKG_DESCRIPTION="TECkit is a library for encoding conversion"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="Henrik Grimler @Grimler91"
TERMUX_PKG_VERSION=2.5.10
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/silnrsi/teckit/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=c80900424f97a9c840332aef4bdf0a4a228d442cf835b4a8ce365351bc99e93b
TERMUX_PKG_DEPENDS="libc++, zlib"
TERMUX_PKG_BREAKS="teckit-dev"
TERMUX_PKG_REPLACES="teckit-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_cv_lib_expat_XML_ExpatVersion=no"

termux_step_pre_configure() {
	./autogen.sh
}
