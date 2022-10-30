TERMUX_PKG_HOMEPAGE=https://dettus.net/dMagnetic
TERMUX_PKG_DESCRIPTION="Interpreter for classic text adventure games and interactive fiction"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.34
TERMUX_PKG_SRCURL=https://dettus.net/dMagnetic/dMagnetic_${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=570b1beb7111874cfbb54fc71868dccc732bc3235b9e5df586d93a4ff2b8e897
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_GROUPS="games"

termux_step_host_build() {
	cd $TERMUX_PKG_BUILDDIR
	make -j $TERMUX_MAKE_PROCESSES dMagnetic
	mv dMagnetic $TERMUX_PKG_HOSTBUILD_DIR/
	make clean
}

termux_step_post_configure() {
	# find our host-built dMagnetic
	export PATH=$TERMUX_PKG_HOSTBUILD_DIR:$PATH
}

termux_step_post_make_install() {
	sed "s%@TERMUX_PREFIX@%$TERMUX_PREFIX%g" \
	    $TERMUX_PKG_BUILDER_DIR/magnetic-scrolls.in \
	    > $TERMUX_PREFIX/bin/magnetic-scrolls
	chmod 700 $TERMUX_PREFIX/bin/magnetic-scrolls
}
