TERMUX_PKG_HOMEPAGE=https://github.com/cathugger/mkp224o
TERMUX_PKG_DESCRIPTION="Generate vanity ed25519 (hidden service version 3) onion addresses"
TERMUX_PKG_LICENSE="CC0-1.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.6.1
TERMUX_PKG_SRCURL=https://github.com/cathugger/mkp224o/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=ba6953588b1a683bdaaf065fbbeebfa7a7db1413e8ba9c9a52e7c90d3a7fa348
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
