TERMUX_PKG_HOMEPAGE=https://en.wikipedia.org/wiki/Mathomatic
TERMUX_PKG_DESCRIPTION="Simple CAS and symbolic calculator"
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_VERSION=16.0.5
TERMUX_PKG_REVISION=5
TERMUX_PKG_SRCURL="https://fossies.org/linux/misc/old/mathomatic-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=7f525bdb2e13006549dd8f17906c26f926f5ac51174f02f074107c612491e05c
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS="READLINE=1"
TERMUX_PKG_DEPENDS="readline"
TERMUX_PKG_RM_AFTER_INSTALL="share/applications/mathomatic.desktop share/pixmaps"
TERMUX_PKG_MAINTAINER="Jonathan Badger @jhbadger"

termux_step_pre_configure() {
	rm $TERMUX_PKG_SRCDIR/CMakeLists.txt
	CPPFLAGS+=" -DUSE_TGAMMA -DBOLD_COLOR"
}
