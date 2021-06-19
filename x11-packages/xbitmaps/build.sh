TERMUX_PKG_HOMEPAGE=https://xorg.freedesktop.org/
TERMUX_PKG_DESCRIPTION="X.org Bitmap files"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Leonid Pliushch <leonid.pliushch@gmail.com>"
TERMUX_PKG_VERSION=1.1.2
TERMUX_PKG_REVISION=29
TERMUX_PKG_SRCURL=https://xorg.freedesktop.org/releases/individual/data/xbitmaps-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=b9f0c71563125937776c8f1f25174ae9685314cbd130fb4c2efce811981e07ee
TERMUX_PKG_BUILD_DEPENDS="xorg-util-macros"
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_NO_DEVELSPLIT=true

termux_step_post_make_install() {
	if [ -f "${TERMUX_PREFIX}/share/pkgconfig/xbitmaps.pc" ]; then
		mkdir -p "${TERMUX_PREFIX}/lib/pkgconfig" || exit 1
		mv -f "${TERMUX_PREFIX}/share/pkgconfig/xbitmaps.pc" "${TERMUX_PREFIX}/lib/pkgconfig/xbitmaps.pc" || exit 1
	fi
}
