TERMUX_PKG_HOMEPAGE=https://www.nano-editor.org/
TERMUX_PKG_DESCRIPTION="Small, free and friendly text editor"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=6.2
TERMUX_PKG_SRCURL=https://nano-editor.org/dist/latest/nano-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=2bca1804bead6aaf4ad791f756e4749bb55ed860eec105a97fba864bc6a77cb3
TERMUX_PKG_DEPENDS="libandroid-support, libandroid-glob, ncurses"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_header_pwd_h=no
--disable-libmagic
--enable-utf8
--with-wordbounds
"
TERMUX_PKG_CONFFILES="etc/nanorc"
TERMUX_PKG_RM_AFTER_INSTALL="bin/rnano share/man/man1/rnano.1 share/nano/man-html"

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-glob"
}

termux_step_post_make_install() {
	# Configure nano to use syntax highlighting:
	NANORC=$TERMUX_PREFIX/etc/nanorc
	echo include \"$TERMUX_PREFIX/share/nano/\*nanorc\" > $NANORC
}

termux_step_create_debscripts() {
	cat <<- EOF > ./postinst
	#!$TERMUX_PREFIX/bin/sh
	if [ "$TERMUX_PACKAGE_FORMAT" = "pacman" ] || [ "\$1" = "configure" ] || [ "\$1" = "abort-upgrade" ]; then
		if [ -x "$TERMUX_PREFIX/bin/update-alternatives" ]; then
			update-alternatives --install \
				$TERMUX_PREFIX/bin/editor editor $TERMUX_PREFIX/bin/nano 20
		fi
	fi
	EOF

	cat <<- EOF > ./prerm
	#!$TERMUX_PREFIX/bin/sh
	if [ "$TERMUX_PACKAGE_FORMAT" = "pacman" ] || [ "\$1" != "upgrade" ]; then
		if [ -x "$TERMUX_PREFIX/bin/update-alternatives" ]; then
			update-alternatives --remove editor $TERMUX_PREFIX/bin/nano
		fi
	fi
	EOF
}
