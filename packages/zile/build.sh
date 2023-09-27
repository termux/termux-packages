TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/zile/
TERMUX_PKG_DESCRIPTION="Lightweight clone of the Emacs text editor"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.6.2
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/zile/zile-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=77eb7daff3c98bdc88daa1ac040dccca72b81dc32fc3166e079dd7a63e42c741
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
		$TERMUX_PKG_SRCDIR/doc/zile.1.in \
		> $TERMUX_PKG_BUILDDIR/doc/zile.1
	touch -d "next hour" $TERMUX_PKG_BUILDDIR/doc/zile.1*
}

termux_step_create_debscripts() {
	cat <<- EOF > ./postinst
	#!$TERMUX_PREFIX/bin/sh
	if [ "$TERMUX_PACKAGE_FORMAT" = "pacman" ] || [ "\$1" = "configure" ] || [ "\$1" = "abort-upgrade" ]; then
		if [ -x "$TERMUX_PREFIX/bin/update-alternatives" ]; then
			update-alternatives --install \
				$TERMUX_PREFIX/bin/editor editor $TERMUX_PREFIX/bin/zile 35
		fi
	fi
	EOF

	cat <<- EOF > ./prerm
	#!$TERMUX_PREFIX/bin/sh
	if [ "$TERMUX_PACKAGE_FORMAT" = "pacman" ] || [ "\$1" != "upgrade" ]; then
		if [ -x "$TERMUX_PREFIX/bin/update-alternatives" ]; then
			update-alternatives --remove editor $TERMUX_PREFIX/bin/zile
		fi
	fi
	EOF
}
