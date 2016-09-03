TERMUX_PKG_HOMEPAGE=http://www.gnupg.org/
TERMUX_PKG_DESCRIPTION="Implementation of the OpenPGP standard for encrypting and signing data and communication"
TERMUX_PKG_VERSION=2.1.15
TERMUX_PKG_SRCURL=ftp://ftp.gnupg.org/gcrypt/gnupg/gnupg-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_DEPENDS="libassuan,libbz2,libgcrypt,libksba,libnpth,readline,pinentry"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-ldap --disable-sqlite"
# Remove non-english help files and man pages shipped with the gnupg (1) package:
TERMUX_PKG_RM_AFTER_INSTALL="share/gnupg/help.*.txt share/man/man1/gpg-zip.1 share/man/man7/gnupg.7"

termux_step_pre_configure() {
	CPPFLAGS+=" -Ddn_skipname=__dn_skipname"
}
