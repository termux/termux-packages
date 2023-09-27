TERMUX_PKG_HOMEPAGE=https://xorg.freedesktop.org/
TERMUX_PKG_DESCRIPTION="Create an index of scalable font files for X"
# Licenses: MIT, HPND
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="COPYING"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.2.2
TERMUX_PKG_SRCURL=https://xorg.freedesktop.org/archive/individual/app/mkfontscale-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=8ae3fb5b1fe7436e1f565060acaa3e2918fe745b0e4979b5593968914fe2d5c4
TERMUX_PKG_DEPENDS="findutils, freetype, libfontenc, zlib"
TERMUX_PKG_BUILD_DEPENDS="xorg-util-macros, xorgproto"
TERMUX_PKG_CONFLICTS="xorg-mkfontdir"
TERMUX_PKG_REPLACES="xorg-mkfontdir"

termux_step_create_debscripts() {
	cp -f "${TERMUX_PKG_BUILDER_DIR}/postinst" ./
	cp -f "${TERMUX_PKG_BUILDER_DIR}/postrm"   ./
	cp -f "${TERMUX_PKG_BUILDER_DIR}/triggers" ./
	sed -i "s|@TERMUX_PREFIX@|$TERMUX_PREFIX|g" ./{post{inst,rm},triggers}
}
