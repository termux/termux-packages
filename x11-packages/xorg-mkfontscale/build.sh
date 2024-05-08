TERMUX_PKG_HOMEPAGE=https://xorg.freedesktop.org/
TERMUX_PKG_DESCRIPTION="Create an index of scalable font files for X"
# Licenses: MIT, HPND
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="COPYING"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.2.3"
TERMUX_PKG_SRCURL=https://xorg.freedesktop.org/archive/individual/app/mkfontscale-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=2921cdc344f1acee04bcd6ea1e29565c1308263006e134a9ee38cf9c9d6fe75e
TERMUX_PKG_AUTO_UPDATE=true
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
