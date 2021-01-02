TERMUX_PKG_HOMEPAGE=https://neomutt.org/
TERMUX_PKG_DESCRIPTION="A version of mutt with added features"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=20201127
TERMUX_PKG_SRCURL=https://github.com/neomutt/neomutt/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=29ac51a5ac5b4524dfdbb5ac78b59a1cc28c1090c541fb3da7bc86f838ab64cd
TERMUX_PKG_DEPENDS="gdbm, krb5, libiconv, libsasl, ncurses, openssl, zlib, zstd"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_CONFFILES="etc/neomuttrc"

termux_step_configure() {
	./configure --host=$TERMUX_HOST_PLATFORM \
		--prefix=$TERMUX_PREFIX --with-mailpath=$PREFIX/var/mail \
		--disable-gpgme --disable-idn --zstd --sasl --ssl --gdbm --gss
}
