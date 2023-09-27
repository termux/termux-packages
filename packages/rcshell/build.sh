TERMUX_PKG_HOMEPAGE=http://tobold.org/article/rc
TERMUX_PKG_DESCRIPTION="An alternative implementation of the plan 9 rc shell"
TERMUX_PKG_LICENSE="ZLIB"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.7.4
TERMUX_PKG_REVISION=4
TERMUX_PKG_SRCURL=https://sources.voidlinux-ppc.org/rc-${TERMUX_PKG_VERSION}/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=0b83f8698dd8ef44ca97b25c4748c087133f53c7fff39b6b70dab65931def8b0
TERMUX_PKG_DEPENDS="readline"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_HOSTBUILD=true

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_func_setpgrp_void=yes
rc_cv_sysv_sigcld=no
"

termux_step_host_build() {
	(cd $TERMUX_PKG_SRCDIR && autoreconf -vfi)
	$TERMUX_PKG_SRCDIR/configure
	make mksignal mkstatval
}

termux_step_pre_configure() {
	autoreconf -vfi
	cp $TERMUX_PKG_HOSTBUILD_DIR/{mksignal,mkstatval} $TERMUX_PKG_BUILDDIR/
	touch -d 'next hour' $TERMUX_PKG_BUILDDIR/{mksignal,mkstatval}
}
