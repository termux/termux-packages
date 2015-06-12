TERMUX_PKG_VERSION=0.161
TERMUX_PKG_HOMEPAGE=https://fedorahosted.org/elfutils/
TERMUX_PKG_DESCRIPTION="ELF object file access library"
TERMUX_PKG_SRCURL=https://fedorahosted.org/releases/e/l/elfutils/${TERMUX_PKG_VERSION}/elfutils-${TERMUX_PKG_VERSION}.tar.bz2

LDFLAGS+=" -lintl"
CFLAGS+=" -DTERMUX_EXPOSE_MEMPCPY=1"

termux_step_pre_make () {
	export TERMUX_PKG_BUILDDIR=$TERMUX_PKG_BUILDDIR/libelf
        cd $TERMUX_PKG_BUILDDIR
}

termux_step_post_make_install () {
        make install-includeHEADERS
}

termux_step_post_massage () {
        # Remove to avoid spurios linking to libelf (https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=10648):
        rm -f $TERMUX_PREFIX/lib/libelf*
}
