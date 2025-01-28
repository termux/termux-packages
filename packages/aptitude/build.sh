TERMUX_PKG_HOMEPAGE=https://wiki.debian.org/Aptitude
TERMUX_PKG_DESCRIPTION="terminal-based package manager"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.8.13
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=http://deb.debian.org/debian/pool/main/a/aptitude/aptitude_$TERMUX_PKG_VERSION.orig.tar.xz
TERMUX_PKG_SHA256=0ef50cb5de27215dd30de74dd9b46b318f017bd0ec3f5c4735df7ac0beb40248
TERMUX_PKG_DEPENDS="apt, boost, libcwidget, libsigc++-2.0, libsqlite, libxapian, ncurses"
TERMUX_PKG_BUILD_DEPENDS="boost-headers, googletest"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-tests
--disable-docs
--disable-boost-lib-checks
--with-boost=$TERMUX_PREFIX
--with-package-state-loc=$TERMUX_PREFIX/var/lib/aptitude
--with-lock-loc=$TERMUX_PREFIX/var/lock/aptitude
--disable-nls
"

termux_step_pre_configure() {
	CXXFLAGS+=" -DNCURSES_WIDECHAR=1"
}

termux_step_create_debscripts() {
	cat <<- EOF > postrm
	#!$TERMUX_PREFIX/bin/sh
	case "\$1" in
	purge)
		rm -fr $TERMUX_PREFIX/var/lib/aptitude
		rm -f $TERMUX_PREFIX/var/log/aptitude $TERMUX_PREFIX/var/log/aptitude.[0-9].gz
		;;
	esac
	EOF
}
