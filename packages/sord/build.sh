TERMUX_PKG_HOMEPAGE=https://drobilla.net/software/sord.html
TERMUX_PKG_DESCRIPTION="A lightweight C library for storing RDF data in memory"
TERMUX_PKG_LICENSE="ISC"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.16.8
TERMUX_PKG_REVISION=0
TERMUX_PKG_SRCURL=https://download.drobilla.net/sord-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=7c289d2eaabf82fa6ac219107ce632d704672dcfb966e1a7ff0bbc4ce93f5e14
TERMUX_PKG_DEPENDS="pcre, serd"
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
