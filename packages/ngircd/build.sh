TERMUX_PKG_HOMEPAGE=https://ngircd.barton.de/
TERMUX_PKG_DESCRIPTION="Free, portable and lightweight Internet Relay Chat server"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@yonle <yonle@protonmail.com>"
TERMUX_PKG_VERSION=26.1
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL="https://github.com/ngircd/ngircd/releases/download/rel-${TERMUX_PKG_VERSION}/ngircd-26.tar.xz"
TERMUX_PKG_SHA256=56dcc6483058699fcdd8e54f5010eecee09824b93bad7ed5f18818e550d855c6
TERMUX_PKG_DEPENDS="zlib, openssl"

# Termux does not use /sbin. Place the binary to $PATH/bin instead
# Also enable OpenSSL & IPv6 support
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--sbindir=$TERMUX_PREFIX/bin
--with-openssl
--enable-ipv6
"

