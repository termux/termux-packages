TERMUX_PKG_HOMEPAGE=http://mcrypt.sourceforge.net/
TERMUX_PKG_DESCRIPTION="A library which provides a uniform interface to several symmetric encryption algorithms"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
TERMUX_PKG_VERSION=2.5.8
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/mcrypt/libmcrypt-$TERMUX_PKG_VERSION.tar.bz2
TERMUX_PKG_SHA256=bf2f1671f44af88e66477db0982d5ecb5116a5c767b0a0d68acb34499d41b793
TERMUX_PKG_BREAKS="libmcrypt-dev"
TERMUX_PKG_REPLACES="libmcrypt-dev"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--mandir=$TERMUX_PREFIX/share/man"
