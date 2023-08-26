TERMUX_PKG_HOMEPAGE=https://scripts.sil.org/teckitdownloads
TERMUX_PKG_DESCRIPTION="TECkit is a library for encoding conversion"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="Henrik Grimler @Grimler91"
TERMUX_PKG_VERSION="2.5.12"
TERMUX_PKG_SRCURL=https://github.com/silnrsi/teckit/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=0ede00cc473fada257a440f590c754af3608076d3d986647af9653ace119b9d5
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++, zlib"
TERMUX_PKG_BREAKS="teckit-dev"
TERMUX_PKG_REPLACES="teckit-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_cv_lib_expat_XML_ExpatVersion=no"

termux_step_pre_configure() {
	./autogen.sh

	LDFLAGS+=" $($CC -print-libgcc-file-name)"
}
