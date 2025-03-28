TERMUX_PKG_HOMEPAGE=https://www.gnupg.org/
TERMUX_PKG_DESCRIPTION="Implementation of the OpenPGP standard for encrypting and signing data and communication"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=(2.5.5
                    1.51)
TERMUX_PKG_SRCURL=(https://www.gnupg.org/ftp/gcrypt/gnupg/gnupg-${TERMUX_PKG_VERSION}.tar.bz2)
# gnupg 2.5.5 needs a newer yat2m version than ubuntu 24.04
# provides. Therefore download also libgpg-error sources and hostbuild
# the tool.
TERMUX_PKG_SRCURL+=(https://www.gnupg.org/ftp/gcrypt/libgpg-error/libgpg-error-${TERMUX_PKG_VERSION[1]}.tar.bz2)
TERMUX_PKG_SHA256=(7afa71d72ff9aaff75a6810b87b486bc492fd752e4f77b07c41759ce4ef36b31
                   be0f1b2db6b93eed55369cdf79f19f72750c8c7c39fc20b577e724545427e6b2)
TERMUX_PKG_DEPENDS="libassuan, libbz2, libgcrypt, libgnutls, libgpg-error, libksba, libnpth, libsqlite, readline, pinentry, resolv-conf, zlib"
TERMUX_PKG_CONFLICTS="gnupg2 (<< 2.2.9-1), dirmngr (<< 2.2.17-1)"
TERMUX_PKG_REPLACES="gnupg2 (<< 2.2.9-1), dirmngr (<< 2.2.17-1)"
TERMUX_PKG_SUGGESTS="scdaemon"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-ldap
--enable-sqlite
--enable-tofu
"
# Remove non-english help files and man pages shipped with the gnupg (1) package:
TERMUX_PKG_RM_AFTER_INSTALL="share/gnupg/help.*.txt share/man/man1/gpg-zip.1 share/man/man7/gnupg.7"
TERMUX_PKG_HOSTBUILD=true

termux_step_host_build() {
	"$TERMUX_PKG_SRCDIR/libgpg-error-${TERMUX_PKG_VERSION[1]}"/configure
	make -C doc yat2m
}

termux_step_pre_configure() {
	export PATH="$TERMUX_PKG_HOSTBUILD_DIR/doc/:$PATH"
	CPPFLAGS+=" -Ddn_skipname=__dn_skipname"
}

termux_step_post_make_install() {
	cd $TERMUX_PREFIX/bin
	ln -sf gpg gpg2
}
