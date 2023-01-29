TERMUX_PKG_HOMEPAGE=https://dettus.net/dMagnetic
TERMUX_PKG_DESCRIPTION="Interpreter for classic text adventure games and interactive fiction"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.36
TERMUX_PKG_SRCURL=https://dettus.net/dMagnetic/dMagnetic_${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=0b7614e47f6711ce58cfbee7188d56d17a92c104004f51ab61798b318e897d8f
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
