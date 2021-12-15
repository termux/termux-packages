TERMUX_PKG_HOMEPAGE=https://scripts.sil.org/teckitdownloads
TERMUX_PKG_DESCRIPTION="TECkit is a library for encoding conversion"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="Henrik Grimler @Grimler91"
TERMUX_PKG_VERSION=2.5.11
TERMUX_PKG_SRCURL=https://github.com/silnrsi/teckit/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=54084e84fc4eb406f1d849f11ba5ba0913b1453c4d16b9946590931723a6297c
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++, zlib"
TERMUX_PKG_BREAKS="teckit-dev"
TERMUX_PKG_REPLACES="teckit-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_cv_lib_expat_XML_ExpatVersion=no"

termux_step_pre_configure() {
	./autogen.sh
}
