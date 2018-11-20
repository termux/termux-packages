TERMUX_PKG_VERSION=0.3.8
TERMUX_PKG_SRCURL=https://www.x.org/archive/individual/driver/xf86-video-dummy-$TERMUX_PKG_VERSION.tar.bz2
TERMUX_PKG_SHA256=3712bb869307233491e4c570732d6073c0dc3d99adfdb9977396a3fdf84e95b9
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_DEPENDS="xorg-server"
termux_step_pre_configure () {
	autoreconf -if
	export LDFLAGS="$LDFLAGS -lXFree86"
}
