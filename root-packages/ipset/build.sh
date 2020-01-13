TERMUX_PKG_HOMEPAGE=http://ipset.netfilter.org
TERMUX_PKG_DESCRIPTION="Administration tool for kernel IP sets"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Vishal Biswas @vishalbiswas"
TERMUX_PKG_VERSION=7.5
TERMUX_PKG_SRCURL=http://ipset.netfilter.org/ipset-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=a57aee54ab6ffe9e04603a464bbf69d66db976500bb04dd04fd3fbd6efb36a0b
TERMUX_PKG_DEPENDS="libmnl, libltdl"
TERMUX_PKG_BREAKS="ipset-dev"
TERMUX_PKG_REPLACES="ipset-dev"
TERMUX_PKG_BUILD_DEPENDS="libtool"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--with-kmod=no
"
