TERMUX_PKG_HOMEPAGE=https://www.spinellis.gr/sw/dgsh/
TERMUX_PKG_DESCRIPTION="The directed graph shell"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.0.0
TERMUX_PKG_SRCURL=https://github.com/dspinellis/dgsh/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=22a7f2794e1287a46b03ce38c27a1d9349d1c66535c30e065c8783626555c76c
TERMUX_PKG_BUILD_DEPENDS="check"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	TERMUX_PKG_SRCDIR=$TERMUX_PKG_SRCDIR/core-tools
	TERMUX_PKG_BUILDDIR=$TERMUX_PKG_SRCDIR
	cd $TERMUX_PKG_BUILDDIR

	sed -i -e 's/#.*$//g' src/dgsh-elf.s
	cp $TERMUX_PKG_BUILDER_DIR/s_cpow.c src/

	touch ../.config
	mkdir -p m4
	autoreconf -fi
}
