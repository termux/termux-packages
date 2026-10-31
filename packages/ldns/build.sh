TERMUX_PKG_HOMEPAGE=https://www.nlnetlabs.nl/projects/ldns/
TERMUX_PKG_DESCRIPTION="Library for simplifying DNS programming and supporting recent and experimental RFCs"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.9.2
TERMUX_PKG_SRCURL=https://www.nlnetlabs.nl/downloads/ldns/ldns-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=b524fa21994b6e834200ceb8c27f1b84bda5982fe35706f058196c079db94d5d
TERMUX_PKG_DEPENDS="openssl, resolv-conf"
TERMUX_PKG_AUTO_UPDATE=true
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
