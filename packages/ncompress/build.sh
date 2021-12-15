TERMUX_PKG_HOMEPAGE=https://github.com/vapier/ncompress
TERMUX_PKG_DESCRIPTION="The classic unix compression utility which can handle the ancient .Z archive"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=5.0
TERMUX_PKG_SRCURL=https://github.com/vapier/ncompress/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=96ec931d06ab827fccad377839bfb91955274568392ddecf809e443443aead46
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make_install() {
	mkdir -p "$TERMUX_PREFIX"/share/man/man1/
	install -Dm700 compress "$TERMUX_PREFIX"/bin/
	install -Dm600 compress.1 "$TERMUX_PREFIX"/share/man/man1/
}
