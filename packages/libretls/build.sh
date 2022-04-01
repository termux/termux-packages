TERMUX_PKG_HOMEPAGE=https://git.causal.agency/libretls/about/
TERMUX_PKG_DESCRIPTION="libtls for OpenSSL"
TERMUX_PKG_LICENSE="ISC"
TERMUX_PKG_MAINTAINER="@Yonle <yonle@duck.com>"
TERMUX_PKG_VERSION=3.5.1
TERMUX_PKG_SRCURL=https://git.causal.agency/libretls/snapshot/libretls-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=dfd1fcf0015b9e99529a9d3c3cf0e4c35b7d778f120a7acc84fedd5ce13bc1f1
TERMUX_PKG_DEPENDS="openssl"
TERMUX_PKG_REPLACES="libtls"
TERMUX_PKG_PROVIDES="libtls"

termux_step_pre_configure() {
	autoreconf -fi
}

termux_step_install_license() {
	install -Dm600 $TERMUX_PKG_BUILDER_DIR/LICENSE -t ${TERMUX_PREFIX}/share/doc/${TERMUX_PKG_NAME}
}
