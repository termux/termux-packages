TERMUX_PKG_HOMEPAGE=https://drobilla.net/software/sratom.html
TERMUX_PKG_DESCRIPTION="A small library for serialising LV2 atoms to and from RDF"
TERMUX_PKG_LICENSE="ISC"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.6.8
TERMUX_PKG_REVISION=0
TERMUX_PKG_SRCURL=https://download.drobilla.net/sratom-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=3acb32b1adc5a2b7facdade2e0818bcd6c71f23f84a1ebc17815bb7a0d2d02df
TERMUX_PKG_DEPENDS="lv2, serd, sord"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_configure() {
	./waf configure \
		--prefix=$TERMUX_PREFIX \
		LINKFLAGS="$LDFLAGS" \
		$TERMUX_PKG_EXTRA_CONFIGURE_ARGS
}

termux_step_make() {
	./waf
}

termux_step_make_install() {
	./waf install
}
