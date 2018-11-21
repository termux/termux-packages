TERMUX_PKG_VERSION=0.5.0
TERMUX_PKG_SRCURL=https://www.x.org/archive/individual/driver/xf86-video-fbdev-$TERMUX_PKG_VERSION.tar.bz2
TERMUX_PKG_SHA256=dcc3d85f378022180e437a9ec00a59b6cb7680ff79c40394d695060af2374699
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_DEPENDS="xorg-server"

termux_step_pre_configure() {
	export LDFLAGS="$LDFLAGS -lXFree86"
}
