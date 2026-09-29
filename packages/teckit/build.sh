TERMUX_PKG_HOMEPAGE=https://scripts.sil.org/teckitdownloads
TERMUX_PKG_DESCRIPTION="TECkit is a library for encoding conversion"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="Henrik Grimler @Grimler91"
TERMUX_PKG_VERSION="2.5.13"
TERMUX_PKG_SRCURL=https://github.com/silnrsi/teckit/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=fa8455324402e890e814f0262e7409dbc8f2a4fd8375c37a11a38ccfc32d3eff
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++, zlib"
TERMUX_PKG_BREAKS="teckit-dev"
TERMUX_PKG_REPLACES="teckit-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_cv_lib_expat_XML_ExpatVersion=no"

termux_step_pre_configure() {
	./autogen.sh

	LDFLAGS+=" $($CC -print-libgcc-file-name)"
}
