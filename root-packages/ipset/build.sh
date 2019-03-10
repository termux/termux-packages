TERMUX_PKG_HOMEPAGE=http://ipset.netfilter.org
TERMUX_PKG_DESCRIPTION="Administration tool for kernel IP sets"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Vishal Biswas @vishalbiswas"
TERMUX_PKG_VERSION=7.1
TERMUX_PKG_SRCURL=http://ipset.netfilter.org/ipset-$TERMUX_PKG_VERSION.tar.bz2
TERMUX_PKG_SHA256=7b5eb3b93205c20cdc39e3fc8b6e5f7bb214bf79a7c0c00729dd4a31ce16adc4

TERMUX_PKG_DEPENDS="libmnl, libltdl"
TERMUX_PKG_BUILD_DEPENDS="libtool"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--with-kmod=no
"
