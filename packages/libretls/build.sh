TERMUX_PKG_HOMEPAGE=https://git.causal.agency/libretls/about/
TERMUX_PKG_DESCRIPTION="libtls for OpenSSL"
TERMUX_PKG_LICENSE="ISC"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.8.1"
TERMUX_PKG_SRCURL=https://git.causal.agency/libretls/snapshot/libretls-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=4a705c9c079dc70383ccc08432b93fbb61f9ec5873a92883e01e0940b8eaf3de
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="openssl"
TERMUX_PKG_REPLACES="libtls"
TERMUX_PKG_PROVIDES="libtls"

termux_step_pre_configure() {
	autoreconf -fi
}

termux_step_install_license() {
	install -Dm600 $TERMUX_PKG_BUILDER_DIR/LICENSE -t ${TERMUX_PREFIX}/share/doc/${TERMUX_PKG_NAME}
}
