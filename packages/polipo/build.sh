TERMUX_PKG_HOMEPAGE=http://www.pps.jussieu.fr/~jch/software/polipo/
TERMUX_PKG_DESCRIPTION="A small and fast caching web proxy"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.1.1
TERMUX_PKG_SRCURL=http://www.pps.univ-paris-diderot.fr/~jch/software/files/polipo/polipo-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=a259750793ab79c491d05fcee5a917faf7d9030fb5d15e05b3704e9c9e4ee015
TERMUX_PKG_DEPENDS="resolv-conf"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_CONFFILES="etc/polipo/config"
TERMUX_PKG_EXTRA_MAKE_ARGS="TARGET=$TERMUX_PKG_MASSAGEDIR"

termux_step_pre_configure() {
	CFLAGS+=" $CPPFLAGS"
}

termux_step_post_make_install() {
	install -Dm600 -t "$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX"/etc/polipo \
		"$TERMUX_PKG_BUILDER_DIR"/termux.config forbidden.sample config.sample
}

termux_step_post_massage() {
	mkdir -p "$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX"/var/cache/polipo
}
