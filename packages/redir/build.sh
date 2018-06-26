TERMUX_PKG_HOMEPAGE=https://github.com/troglobit/redir
TERMUX_PKG_DESCRIPTION="TCP port redirector for UNIX"
TERMUX_PKG_VERSION=3.2
TERMUX_PKG_SHA256=e3c61bc4a51cf9228f916aeee3cb510bdff29ec2cdc2a1c8ae43d597bec89baa
TERMUX_PKG_SRCURL=https://github.com/troglobit/redir/releases/download/v$TERMUX_PKG_VERSION/redir-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_BUILD_IN_SRC="yes"
TERMUX_PKG_RM_AFTER_INSTALL="share/applications share/pixmaps"

termux_step_pre_configure() {
	LDFLAGS+=" -llog"
}
