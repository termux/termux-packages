TERMUX_PKG_HOMEPAGE=https://github.com/troglobit/redir
TERMUX_PKG_DESCRIPTION="TCP port redirector for UNIX"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=3.3
TERMUX_PKG_SHA256=7ce53ac52a24c1b3279b994bfffbd429c44df2db10a4b1a0f54e108604fdae6e
TERMUX_PKG_SRCURL=https://github.com/troglobit/redir/releases/download/v$TERMUX_PKG_VERSION/redir-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_RM_AFTER_INSTALL="share/applications share/pixmaps"

termux_step_pre_configure() {
	LDFLAGS+=" -llog"
}
