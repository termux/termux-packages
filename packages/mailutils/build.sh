TERMUX_PKG_HOMEPAGE=https://mailutils.org/
TERMUX_PKG_DESCRIPTION="Mailutils is a swiss army knife of electronic mail handling. "
TERMUX_PKG_LICENSE="LGPL-3.0, GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.19"
TERMUX_PKG_SRCURL=https://ftp.gnu.org/gnu/mailutils/mailutils-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=50230d20036c5b8ad8c96b0d996177f1f133fba4c7c7e3b462d39eeb30849f45
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libandroid-glob, libcrypt, libiconv, libltdl, libunistring, ncurses, readline"
# Most of these configure arguments are for avoiding automagic dependencies.
# You may instead add dependencies properly and enable them.
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-python
--without-gssapi
--without-gnutls
--without-gdbm
--without-berkeley-db
--without-fribidi
--without-ldap
--without-guile
"

termux_step_pre_configure() {
	export LIBS="-landroid-glob"
}
