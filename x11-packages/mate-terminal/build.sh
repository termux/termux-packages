TERMUX_PKG_HOMEPAGE=https://mate-terminal.mate-desktop.dev/
TERMUX_PKG_DESCRIPTION="This is the MATE terminal emulator application"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.26.1
TERMUX_PKG_SRCURL=https://github.com/mate-desktop/mate-terminal/releases/download/v$TERMUX_PKG_VERSION/mate-terminal-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=7c130206f0b47887e8c9274e73f8c19fae511134572869a7c23111b789e1e1d0
TERMUX_PKG_DEPENDS="libvte, dconf, gtk3, libsm, mate-desktop"

termux_step_pre_configure() {
	autoreconf -vfi
}
