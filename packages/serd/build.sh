TERMUX_PKG_HOMEPAGE=https://drobilla.net/software/serd.html
TERMUX_PKG_DESCRIPTION="A lightweight C library for RDF syntax"
TERMUX_PKG_LICENSE="ISC"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.30.10
TERMUX_PKG_REVISION=0
TERMUX_PKG_SRCURL=https://download.drobilla.net/serd-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=affa80deec78921f86335e6fc3f18b80aefecf424f6a5755e9f2fa0eb0710edf
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
