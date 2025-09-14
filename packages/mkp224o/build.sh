TERMUX_PKG_HOMEPAGE=https://github.com/cathugger/mkp224o
TERMUX_PKG_DESCRIPTION="Generate vanity ed25519 (hidden service version 3) onion addresses"
TERMUX_PKG_LICENSE="CC0-1.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.7.0"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/cathugger/mkp224o/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=e7bda8517206a1786d97c793a2b7ad91be88e73ed2e7d9aad986f3bd5e3fdb5e
TERMUX_PKG_DEPENDS="libsodium"
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	autoconf -f

	# configure scripts tries to get version from git, or this file:
	echo "v$TERMUX_PKG_VERSION" > $TERMUX_PKG_SRCDIR/version.txt
}

termux_step_make_install() {
	install -m700 mkp224o $TERMUX_PREFIX/bin/
}
