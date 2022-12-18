TERMUX_PKG_HOMEPAGE=https://www.gap-system.org/
TERMUX_PKG_DESCRIPTION="GAP is a system for computational discrete algebra, with particular emphasis on Computational Group Theory"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=4.12.2
TERMUX_PKG_SRCURL=https://github.com/gap-system/gap/releases/download/v${TERMUX_PKG_VERSION}/gap-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=672308745eb78a222494ee8dd6786edd5bc331456fcc6456ac064bdb28d587a8
TERMUX_PKG_DEPENDS="readline, libgmp, zlib, gap-packages"
TERMUX_PKG_BREAKS="gap-dev"
TERMUX_PKG_REPLACES="gap-dev"
TERMUX_PKG_GROUPS="science"

termux_step_post_make_install() {
	mkdir -p $TERMUX_PREFIX/lib/gap/pkg
	# install at least gapdoc, smallgrp, transgrp, primgrp or else
	# this package is mostly useless.
	cp -r $TERMUX_PKG_SRCDIR/pkg/gapdoc $TERMUX_PREFIX/lib/gap/pkg/
	cp -r $TERMUX_PKG_SRCDIR/pkg/smallgrp $TERMUX_PREFIX/lib/gap/pkg/
	cp -r $TERMUX_PKG_SRCDIR/pkg/transgrp $TERMUX_PREFIX/lib/gap/pkg/
	cp -r $TERMUX_PKG_SRCDIR/pkg/primgrp $TERMUX_PREFIX/lib/gap/pkg/

	# To save some disk space, compress transgrp data in place
	# (GAP transparently allows read access to those)
	gzip -9 -n -f $TERMUX_PREFIX/lib/gap/pkg/transgrp/data/*.*
}
