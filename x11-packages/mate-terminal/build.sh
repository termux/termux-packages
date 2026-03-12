TERMUX_PKG_HOMEPAGE=https://mate-terminal.mate-desktop.dev/
TERMUX_PKG_DESCRIPTION="This is the MATE terminal emulator application"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.28.2"
TERMUX_PKG_SRCURL=https://github.com/mate-desktop/mate-terminal/releases/download/v$TERMUX_PKG_VERSION/mate-terminal-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=a74e55a992daea9b48aa6ddbed0cc176e6da7f68b2b454d1921edf3beec00b9f
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libvte, dconf, gtk3, libsm, mate-desktop"

termux_step_pre_configure() {
	autoreconf -vfi
}
