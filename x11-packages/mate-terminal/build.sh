TERMUX_PKG_HOMEPAGE=https://mate-terminal.mate-desktop.dev/
TERMUX_PKG_DESCRIPTION="This is the MATE terminal emulator application"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.28.1"
TERMUX_PKG_SRCURL=https://github.com/mate-desktop/mate-terminal/releases/download/v$TERMUX_PKG_VERSION/mate-terminal-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=f135eb1a9e2ae22798ecb2dc1914fdb4cfd774e6bb65c0152be37cc6c9469e92
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libvte, dconf, gtk3, libsm, mate-desktop"

termux_step_pre_configure() {
	autoreconf -vfi
}
