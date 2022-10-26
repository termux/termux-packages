TERMUX_PKG_HOMEPAGE=https://www.gap-system.org/
TERMUX_PKG_DESCRIPTION="GAP is a system for computational discrete algebra, with particular emphasis on Computational Group Theory"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=4.12.1
TERMUX_PKG_SRCURL=https://github.com/gap-system/gap/releases/download/v${TERMUX_PKG_VERSION}/gap-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=f9ebef11ee31b210ce36e3c70960742b4e253282bbd5270adc9324273c92b016
TERMUX_PKG_DEPENDS="readline, libgmp, zlib, gap-packages"
TERMUX_PKG_BREAKS="gap-dev"
TERMUX_PKG_REPLACES="gap-dev"
TERMUX_PKG_GROUPS="science"

termux_step_post_configure() {
	# workaround build system bug that occurs when doing
	# an out-of-tree cross compilation build
	mkdir -p src
	cp $TERMUX_PKG_SRCDIR/src/ffdata.* src/
	cp $TERMUX_PKG_SRCDIR/src/c_*.c src/
}

termux_step_post_make_install() {
	mkdir -p $TERMUX_PREFIX/lib/gap/pkg
	# install at least gapdoc, smallgrp, transgrp, primgrp or else
	# this package is mostly useless.
	cp -r $TERMUX_PKG_SRCDIR/pkg/gapdoc $TERMUX_PREFIX/lib/gap/pkg/
	cp -r $TERMUX_PKG_SRCDIR/pkg/smallgrp $TERMUX_PREFIX/lib/gap/pkg/
	cp -r $TERMUX_PKG_SRCDIR/pkg/transgrp $TERMUX_PREFIX/lib/gap/pkg/
	cp -r $TERMUX_PKG_SRCDIR/pkg/primgrp $TERMUX_PREFIX/lib/gap/pkg/

	# To get them to be small enough, could gzip them in place
	# (GAP transparently allows read access to those)
	gzip -9 -n -f $TERMUX_PREFIX/lib/gap/pkg/*/data/*.*
	gzip -9 -n -f $TERMUX_PREFIX/lib/gap/pkg/smallgrp/id*/*.*
	gzip -9 -n -f $TERMUX_PREFIX/lib/gap/pkg/smallgrp/small*/*.*
}
