TERMUX_PKG_HOMEPAGE=https://neomutt.org/
TERMUX_PKG_DESCRIPTION="A version of mutt with added features"
# License: GPL-2.0-or-later
TERMUX_PKG_LICENSE="GPL-2.0, GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="20230512"
TERMUX_PKG_SRCURL=https://github.com/neomutt/neomutt/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=44a6c9d8e6f58c6a3b21b6af5f044ffd0ed2deb1a7cdc6bdda14669917bd09c4
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d{8}"
TERMUX_PKG_DEPENDS="gdbm, krb5, libandroid-support, libiconv, libsasl, ncurses, notmuch, openssl, zlib, zstd"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_CONFFILES="etc/neomuttrc"

termux_step_configure() {
	./configure --host=$TERMUX_HOST_PLATFORM \
		--sysroot=$TERMUX_PREFIX \
		--prefix=$TERMUX_PREFIX --with-mailpath=$TERMUX_PREFIX/var/mail \
		--notmuch \
		--disable-gpgme --disable-idn --zlib --zstd --sasl --ssl --gdbm --gss
}
