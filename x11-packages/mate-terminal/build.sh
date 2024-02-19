TERMUX_PKG_HOMEPAGE=https://mate-terminal.mate-desktop.dev/
TERMUX_PKG_DESCRIPTION="This is the MATE terminal emulator application"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.28.0"
TERMUX_PKG_SRCURL=https://github.com/mate-desktop/mate-terminal/releases/download/v$TERMUX_PKG_VERSION/mate-terminal-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=dea52c6fe8d61005ba5f85a7cbf0d096c27b90bcec3f915421ce81e5f7dd1692
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libvte, dconf, gtk3, libsm, mate-desktop"

termux_step_pre_configure() {
	autoreconf -vfi
}
