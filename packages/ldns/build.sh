TERMUX_PKG_HOMEPAGE=https://www.nlnetlabs.nl/projects/ldns/
TERMUX_PKG_DESCRIPTION="Library for simplifying DNS programming and supporting recent and experimental RFCs"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.8.3
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://www.nlnetlabs.nl/downloads/ldns/ldns-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=c3f72dd1036b2907e3a56e6acf9dfb2e551256b3c1bbd9787942deeeb70e7860
TERMUX_PKG_DEPENDS="openssl, resolv-conf"
TERMUX_PKG_BREAKS="ldns-dev"
TERMUX_PKG_REPLACES="ldns-dev"
TERMUX_PKG_BUILD_IN_SRC=true

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--with-ssl=$TERMUX_PREFIX
--disable-gost
--with-drill
"

termux_step_pre_configure() {
	autoreconf -fi
}

termux_step_post_make_install() {
	# The ldns build doesn't install its pkg-config:
	mkdir -p $TERMUX_PREFIX/lib/pkgconfig
	cp packaging/libldns.pc $TERMUX_PREFIX/lib/pkgconfig/libldns.pc
}
