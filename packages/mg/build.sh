TERMUX_PKG_HOMEPAGE=https://github.com/hboetes/mg
TERMUX_PKG_DESCRIPTION="microscopic GNU Emacs-style editor"
TERMUX_PKG_LICENSE="Public Domain"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=20180927
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/hboetes/mg/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=fbb09729ea00fe42dcdbc96ac7fc1d2b89eac651dec49e4e7af52fad4f5788f6
TERMUX_PKG_DEPENDS="libbsd, ncurses"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	CFLAGS+=" $CPPFLAGS"
}

termux_step_make_install() {
	make prefix=$PREFIX install
}

termux_step_create_debscripts() {
	cat <<- EOF > ./postinst
	#!$TERMUX_PREFIX/bin/sh
	if [ "\$1" = "configure" ] || [ "\$1" = "abort-upgrade" ]; then
		if [ -x "$TERMUX_PREFIX/bin/update-alternatives" ]; then
			update-alternatives --install \
				$TERMUX_PREFIX/bin/editor editor $TERMUX_PREFIX/bin/mg 30
		fi
	fi
	EOF

	cat <<- EOF > ./prerm
	#!$TERMUX_PREFIX/bin/sh
	if [ "\$1" != "upgrade" ]; then
		if [ -x "$TERMUX_PREFIX/bin/update-alternatives" ]; then
			update-alternatives --remove editor $TERMUX_PREFIX/bin/mg
		fi
	fi
	EOF
}
