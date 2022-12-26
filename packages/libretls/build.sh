TERMUX_PKG_HOMEPAGE=https://git.causal.agency/libretls/about/
TERMUX_PKG_DESCRIPTION="libtls for OpenSSL"
TERMUX_PKG_LICENSE="ISC"
TERMUX_PKG_MAINTAINER="@Yonle <yonle@duck.com>"
TERMUX_PKG_VERSION=3.7.0
TERMUX_PKG_SRCURL=https://git.causal.agency/libretls/snapshot/libretls-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=cd72a37e93f8376c2e6310d30d39cda3d0f358bf3763d3ff22faf2454c3b25ed
TERMUX_PKG_DEPENDS="openssl"
TERMUX_PKG_REPLACES="libtls"
TERMUX_PKG_PROVIDES="libtls"

termux_step_pre_configure() {
	autoreconf -fi
}

termux_step_install_license() {
	install -Dm600 $TERMUX_PKG_BUILDER_DIR/LICENSE -t ${TERMUX_PREFIX}/share/doc/${TERMUX_PKG_NAME}
}
