TERMUX_PKG_HOMEPAGE=https://gts.sourceforge.net/
TERMUX_PKG_DESCRIPTION="Provides useful functions to deal with 3D surfaces meshed with interconnected triangles"
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.7.6
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/project/gts/gts/${TERMUX_PKG_VERSION}/gts-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=059c3e13e3e3b796d775ec9f96abdce8f2b3b5144df8514eda0cc12e13e8b81e
TERMUX_PKG_DEPENDS="glib"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_HOSTBUILD=true

termux_step_host_build() {
	# predicates_init executable generates predicates_init.h
	$TERMUX_PKG_SRCDIR/configure
	make -C src predicates_init
}
