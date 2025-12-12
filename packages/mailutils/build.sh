TERMUX_PKG_HOMEPAGE=https://mailutils.org/
TERMUX_PKG_DESCRIPTION="Mailutils is a swiss army knife of electronic mail handling. "
TERMUX_PKG_LICENSE="LGPL-3.0, GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.21"
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/mailutils/mailutils-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=e47c1edc699b8d6675fdbc77db3a84ae837f18e1f2094fe29d48bb58a97ef5e9
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
