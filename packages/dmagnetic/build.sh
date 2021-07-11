TERMUX_PKG_HOMEPAGE=https://www.dettus.net/dMagnetic
TERMUX_PKG_DESCRIPTION="Interpreter for classic text adventure games and interactive fiction"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.31
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://www.dettus.net/dMagnetic/dMagnetic_${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=1a0356f04d3a5e252225b0fd38b9047957f292f67338ba83579958b46f184139
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_HOSTBUILD=true

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
