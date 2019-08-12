TERMUX_PKG_HOMEPAGE=https://www.nlnetlabs.nl/projects/ldns/
TERMUX_PKG_DESCRIPTION="Library for simplifying DNS programming and supporting recent and experimental RFCs"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_VERSION=1.7.1
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://www.nlnetlabs.nl/downloads/ldns/ldns-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=8ac84c16bdca60e710eea75782356f3ac3b55680d40e1530d7cea474ac208229
TERMUX_PKG_DEPENDS="openssl"
TERMUX_PKG_BREAKS="ldns-dev"
TERMUX_PKG_REPLACES="ldns-dev"
TERMUX_PKG_BUILD_IN_SRC=true

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--with-ssl=$TERMUX_PREFIX
--disable-gost
"

termux_step_post_make_install() {
	# The ldns build doesn't install its pkg-config:
	mkdir -p $TERMUX_PREFIX/lib/pkgconfig
	cp packaging/libldns.pc $TERMUX_PREFIX/lib/pkgconfig/libldns.pc
}
