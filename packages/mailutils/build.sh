TERMUX_PKG_HOMEPAGE=https://mailutils.org/
TERMUX_PKG_DESCRIPTION="Mailutils is a swiss army knife of electronic mail handling. "
TERMUX_PKG_LICENSE="LGPL-3.0, GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.20"
TERMUX_PKG_SRCURL=https://ftp.gnu.org/gnu/mailutils/mailutils-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=a8f3faab1edda5188bb5ca3e4e9c0c5bc72cd0dadf4e1f4799d27fa75c6ae829
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="gdbm, libandroid-glob, libcrypt, libiconv, libltdl, libunistring, ncurses, readline"
# Most of these configure arguments are for avoiding automagic dependencies.
# You may instead add dependencies properly and enable them.
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-python
--disable-static
--without-gssapi
--without-gnutls
--without-berkeley-db
--without-fribidi
--without-ldap
--without-guile
"

termux_step_pre_configure() {
	export LIBS="-landroid-glob"
}
