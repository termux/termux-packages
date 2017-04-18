TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/zile/
TERMUX_PKG_DESCRIPTION="Lightweight clone of the Emacs text editor"
TERMUX_PKG_MAINTAINER="Iain Nicol @iainnicol"
TERMUX_PKG_VERSION=2.4.13
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/zile/zile-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=c795f369ea432219c21bf59ffc9322fd5f221217021a8fbaa6f9fed91778ac0e
TERMUX_PKG_DEPENDS="libgc, ncurses"
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_post_configure() {
	# zile uses help2man to build the zile.1 man page, which would require
	# a host build. To avoid that just copy a pre-built man page.
	cp $TERMUX_PKG_BUILDER_DIR/zile.1 $TERMUX_PKG_BUILDDIR/doc/zile.1
	touch -d "next hour" $TERMUX_PKG_BUILDDIR/doc/zile.1*
}
