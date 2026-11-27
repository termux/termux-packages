TERMUX_PKG_HOMEPAGE=https://ngircd.barton.de/
TERMUX_PKG_DESCRIPTION="Free, portable and lightweight Internet Relay Chat server"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="29"
TERMUX_PKG_SRCURL="https://github.com/ngircd/ngircd/releases/download/rel-${TERMUX_PKG_VERSION}/ngircd-${TERMUX_PKG_VERSION%.*}.tar.xz"
TERMUX_PKG_SHA256=4d681074619284c230842f865a2586e49e166a352de6e577feca692d21b2d5f5
TERMUX_PKG_AUTO_UPDATE=true
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
