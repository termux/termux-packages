TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/bc/
TERMUX_PKG_DESCRIPTION="Arbitrary precision numeric processing language"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.07.1
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/bc/bc-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=62adfca89b0a1c0164c2cdca59ca210c1d44c3ffc46daf9931cf4942664cb02a
TERMUX_PKG_DEPENDS="readline,flex"
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--infodir=$TERMUX_PREFIX/share/info
--mandir=$TERMUX_PREFIX/share/man
--with-readline
"

termux_step_pre_configure() {
	cp $TERMUX_PKG_HOSTBUILD_DIR/bc/libmath.h \
	   $TERMUX_PKG_SRCDIR/bc/libmath.h
	touch -d "next hour" $TERMUX_PKG_SRCDIR/bc/libmath.h
}
