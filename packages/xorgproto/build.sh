# X11 package
TERMUX_PKG_HOMEPAGE=https://xorg.freedesktop.org/
TERMUX_PKG_DESCRIPTION="X.Org X11 Protocol headers"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_LICENSE_FILE="COPYING-bigreqsproto, COPYING-compositeproto, COPYING-damageproto, COPYING-dmxproto, COPYING-dri2proto, COPYING-dri3proto, COPYING-evieproto, COPYING-fixesproto, COPYING-fontcacheproto, COPYING-fontsproto, COPYING-glproto, COPYING-inputproto, COPYING-kbproto, COPYING-lg3dproto, COPYING-pmproto, COPYING-presentproto, COPYING-printproto, COPYING-randrproto, COPYING-recordproto, COPYING-renderproto, COPYING-resourceproto, COPYING-scrnsaverproto, COPYING-trapproto, COPYING-videoproto, COPYING-x11proto, COPYING-xcmiscproto, COPYING-xextproto, COPYING-xf86bigfontproto, COPYING-xf86dgaproto, COPYING-xf86driproto, COPYING-xf86miscproto, COPYING-xf86rushproto, COPYING-xf86vidmodeproto, COPYING-xineramaproto"
TERMUX_PKG_MAINTAINER="Leonid Pliushch <leonid.pliushch@gmail.com>"
TERMUX_PKG_VERSION=2020.1
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://xorg.freedesktop.org/archive/individual/proto/xorgproto-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=54a153f139035a376c075845dd058049177212da94d7a9707cf9468367b699d2
TERMUX_PKG_DEPENDS="xorg-util-macros"
TERMUX_PKG_CONFLICTS="x11-proto"
TERMUX_PKG_REPLACES="x11-proto"
TERMUX_PKG_NO_DEVELSPLIT=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-Dlegacy=true"

TERMUX_PKG_RM_AFTER_INSTALL="
include/X11/extensions/apple*
include/X11/extensions/windows*
include/X11/extensions/XKBgeom.h
lib/pkgconfig/applewmproto.pc
lib/pkgconfig/windowswmproto.pc
"

termux_step_pre_configure() {
	# Use meson instead of autotools.
	rm -f "$TERMUX_PKG_SRCDIR"/configure
}
