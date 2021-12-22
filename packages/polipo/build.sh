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

termux_step_pre_configure() {
	CFLAGS+=" $CPPFLAGS"
}

termux_step_post_make_install() {
	install -Dm600 config.sample "$TERMUX_PREFIX"/etc/polipo/config.sample
	install -Dm600 forbidden.sample "$TERMUX_PREFIX"/etc/polipo/forbidden.sample
	install -Dm600 "$TERMUX_PKG_BUILDER_DIR"/termux.config \
		"$TERMUX_PREFIX"/etc/polipo/config
}

termux_step_post_massage() {
	mkdir -p "$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX"/var/cache/polipo
}
