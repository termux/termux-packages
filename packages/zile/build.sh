TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/zile/
TERMUX_PKG_DESCRIPTION="Lightweight clone of the Emacs text editor"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="Iain Nicol @iainnicol"
TERMUX_PKG_VERSION=2.4.14
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/zile/zile-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=7a78742795ca32480f2bab697fd5e328618d9997d6f417cf1b14e9da9af26b74
TERMUX_PKG_DEPENDS="libgc, ncurses"
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_post_configure() {
	# zile uses help2man to build the zile.1 man page, which would require
	# a host build. To avoid that just copy a pre-built man page.
	cp $TERMUX_PKG_BUILDER_DIR/zile.1 $TERMUX_PKG_BUILDDIR/doc/zile.1
	touch -d "next hour" $TERMUX_PKG_BUILDDIR/doc/zile.1*
}
