TERMUX_PKG_HOMEPAGE=https://ne.di.unimi.it/
TERMUX_PKG_DESCRIPTION="Easy-to-use and powerful text editor"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.3.1
TERMUX_PKG_SRCURL=https://github.com/vigna/ne/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=931f01380b48e539b06d65d80ddf313cce67aab6d7b62462a548253ab9b3e10a
TERMUX_PKG_DEPENDS="libandroid-support, ncurses"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"

termux_step_pre_configure() {
	export OPTS="$CFLAGS $CPPFLAGS"
}

termux_step_create_debscripts() {
	cat <<- EOF > ./postinst
	#!$TERMUX_PREFIX/bin/sh
	if [ "$TERMUX_PACKAGE_FORMAT" = "pacman" ] || [ "\$1" = "configure" ] || [ "\$1" = "abort-upgrade" ]; then
		if [ -x "$TERMUX_PREFIX/bin/update-alternatives" ]; then
			update-alternatives --install \
				$TERMUX_PREFIX/bin/editor editor $TERMUX_PREFIX/bin/ne 15
		fi
	fi
	EOF

	cat <<- EOF > ./prerm
	#!$TERMUX_PREFIX/bin/sh
	if [ "$TERMUX_PACKAGE_FORMAT" = "pacman" ] || [ "\$1" != "upgrade" ]; then
		if [ -x "$TERMUX_PREFIX/bin/update-alternatives" ]; then
			update-alternatives --remove editor $TERMUX_PREFIX/bin/ne
		fi
	fi
	EOF
}
