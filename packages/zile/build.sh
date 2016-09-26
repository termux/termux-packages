TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/zile/
TERMUX_PKG_DESCRIPTION="Lightweight clone of the Emacs text editor"
TERMUX_PKG_MAINTAINER="Iain Nicol @iainnicol"
TERMUX_PKG_VERSION=2.4.11
TERMUX_PKG_BUILD_REVISION=3
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/zile/zile-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="libgc, ncurses"
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_pre_make () {
	# zile uses help2man to build the zile.1 man page, which would require
	# a host build. To avoid that just copy a pre-built man page.
	cp $TERMUX_PKG_BUILDER_DIR/zile.1 $TERMUX_PKG_BUILDDIR/doc/zile.1
	$TERMUX_TOUCH -d "next hour" $TERMUX_PKG_BUILDDIR/doc/zile.1*
}
