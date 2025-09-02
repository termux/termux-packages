TERMUX_PKG_HOMEPAGE=https://ngspice.sourceforge.net/
TERMUX_PKG_DESCRIPTION="A mixed-level/mixed-signal circuit simulator"
TERMUX_PKG_LICENSE="BSD 3-Clause, LGPL-2.1"
TERMUX_PKG_LICENSE_FILE="COPYING"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="45"
TERMUX_PKG_SRCURL=https://github.com/imr/ngspice/archive/refs/tags/ngspice-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=f32435556d063419442c264bb6756df9663c57a85cd3d286847b8c21ab5c498b
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
TERMUX_PKG_UPDATE_VERSION_SED_REGEXP="s/ngspice-//"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-cider
--enable-openmp
--enable-xspice
--with-x=no
--with-readline=yes
"
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_HOSTBUILD_CONFIGURE_ARGS="
--enable-cider
--enable-xspice
--with-x=no
"
TERMUX_PKG_DEPENDS="fftw, libc++, ncurses, readline"
TERMUX_PKG_GROUPS="science"

termux_step_host_build() {
	autoreconf -fi $TERMUX_PKG_SRCDIR
	$TERMUX_PKG_SRCDIR/configure $TERMUX_PKG_EXTRA_HOSTBUILD_CONFIGURE_ARGS

	# compiles ngspice codemodel preprocessor
	cd src/xspice/cmpp && make -j $TERMUX_PKG_MAKE_PROCESSES
}

termux_step_pre_configure() {
	LDFLAGS+=" -fopenmp -static-openmp"

	# ERROR: ./lib/ngspice/ivlng.vpi contains undefined symbols: pow
	LDFLAGS+=" -lm"

	autoreconf -fi
}

termux_step_post_configure() {
	cp -ru $TERMUX_PKG_HOSTBUILD_DIR/src/xspice/cmpp \
		src/xspice
	cd src/xspice/cmpp && cp cmpp build/cmpp

	# prevents building again on copied precompiled cmpp.
	touch -d "next hour" *
}
