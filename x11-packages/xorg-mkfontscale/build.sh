TERMUX_PKG_HOMEPAGE=https://xorg.freedesktop.org/
TERMUX_PKG_DESCRIPTION="Create an index of scalable font files for X"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Leonid Pliushch <leonid.pliushch@gmail.com>"
TERMUX_PKG_VERSION=1.2.1
TERMUX_PKG_REVISION=21
TERMUX_PKG_SRCURL=https://xorg.freedesktop.org/archive/individual/app/mkfontscale-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=ca0495eb974a179dd742bfa6199d561bda1c8da4a0c5a667f21fd82aaab6bac7
TERMUX_PKG_DEPENDS="findutils, freetype, libfontenc, zlib"
TERMUX_PKG_BUILD_DEPENDS="xorg-util-macros, xorgproto"
TERMUX_PKG_CONFLICTS="xorg-mkfontdir"
TERMUX_PKG_REPLACES="xorg-mkfontdir"

termux_step_create_debscripts() {
	cp -f "${TERMUX_PKG_BUILDER_DIR}/postinst" ./
	cp -f "${TERMUX_PKG_BUILDER_DIR}/postrm"   ./
	cp -f "${TERMUX_PKG_BUILDER_DIR}/triggers" ./
}
