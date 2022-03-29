TERMUX_PKG_HOMEPAGE=https://git.causal.agency/libretls/about/
TERMUX_PKG_DESCRIPTION="libtls for OpenSSL"
TERMUX_PKG_LICENSE="BSD"
# There's no license file in the tarball source
# Instead, copy README.7 as it also includes what LICENSE that they use.
TERMUX_PKG_LICENSE_FILE="README.7"
TERMUX_PKG_MAINTAINER="@Yonle <yonle@duck.com>"
TERMUX_PKG_VERSION=3.5.1
TERMUX_PKG_SRCURL=https://git.causal.agency/libretls/snapshot/libretls-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=dfd1fcf0015b9e99529a9d3c3cf0e4c35b7d778f120a7acc84fedd5ce13bc1f1
TERMUX_PKG_DEPENDS="openssl"
TERMUX_PKG_REPLACES="libtls"
TERMUX_PKG_PROVIDEs="libtls"

termux_step_pre_configure(){
	autoreconf -fi
}
