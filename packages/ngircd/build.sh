TERMUX_PKG_HOMEPAGE=https://ngircd.barton.de/
TERMUX_PKG_DESCRIPTION="Free, portable and lightweight Internet Relay Chat server"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@Yonle"
TERMUX_PKG_VERSION="27"
TERMUX_PKG_SRCURL="https://github.com/ngircd/ngircd/releases/download/rel-${TERMUX_PKG_VERSION}/ngircd-${TERMUX_PKG_VERSION%.*}.tar.xz"
TERMUX_PKG_SHA256=6897880319dd5e2e73c1c9019613509f88eb5b8daa5821a36fbca3d785c247b8
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_SED_REGEXP='s/^[^-]*-//;s/-.*//'
TERMUX_PKG_DEPENDS="zlib, openssl"

# Termux does not use /sbin. Place the binary to $PATH/bin instead
# Also enable OpenSSL & IPv6 support
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--sbindir=$TERMUX_PREFIX/bin
--with-openssl
--enable-ipv6
"

termux_step_pre_configure() {
	sed -i.orig "s:endpwent ::g" "$TERMUX_PKG_SRCDIR/configure"
}
