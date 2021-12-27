TERMUX_PKG_HOMEPAGE=https://sourceforge.net/projects/vbisam/
TERMUX_PKG_DESCRIPTION="A replacement for IBM's C-ISAM"
TERMUX_PKG_LICENSE="GPL-2.0, LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.0
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/project/vbisam/vbisam2/vbisam-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=688b776e0030cce50fd7e44cbe40398ea93431f76510c7100433cc6313eabc4f

termux_step_pre_configure() {
	cp $TERMUX_PKG_BUILDER_DIR/efgcvt_r-template.c $TERMUX_PKG_SRCDIR/libvbisam/
	cp $TERMUX_PKG_BUILDER_DIR/efgcvt-dbl-macros.h $TERMUX_PKG_SRCDIR/libvbisam/
	autoreconf -fi
}
