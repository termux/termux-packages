TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/zile/
TERMUX_PKG_DESCRIPTION="Lightweight clone of the Emacs text editor"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.6.4"
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/zile/zile-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=d5d44b85cb490643d0707e1a2186f3a32998c2f6eabaa9481479b65caeee57c0
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="glib, libgee, ncurses"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_header_spawn_h=no
gl_cv_have_weak=no
"

termux_step_post_configure() {
	# zile uses help2man to build the zile.1 man page, which would require
	# a host build.
	sed 's|@docdir@|$PREFIX/share/doc/zile|g' \
		"$TERMUX_PKG_SRCDIR/doc/zile.1.in" \
		> "$TERMUX_PKG_BUILDDIR/doc/zile.1"
	touch -d "next hour" "$TERMUX_PKG_BUILDDIR/doc/zile.1"*
}
