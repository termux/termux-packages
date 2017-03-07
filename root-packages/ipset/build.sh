TERMUX_PKG_HOMEPAGE=http://ipset.netfilter.org
TERMUX_PKG_VERSION=6.31
TERMUX_PKG_SRCURL=http://ipset.netfilter.org/ipset-$TERMUX_PKG_VERSION.tar.bz2
TERMUX_PKG_SHA256=498e411cc1d134201a31a56def6c0936c642958c2d4b4ce7d9955240047a45fe
TERMUX_PKG_MAINTAINER="Vishal Biswas @vishalbiswas"
TERMUX_PKG_DESCRIPTION="Administration tool for kernel IP sets"
TERMUX_PKG_DEPENDS="libmnl"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--with-kmod=no
"
