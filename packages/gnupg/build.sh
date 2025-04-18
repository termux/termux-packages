TERMUX_PKG_HOMEPAGE=https://www.gnupg.org/
TERMUX_PKG_DESCRIPTION="Implementation of the OpenPGP standard for encrypting and signing data and communication"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.5.5
TERMUX_PKG_SRCURL=https://www.gnupg.org/ftp/gcrypt/gnupg/gnupg-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=7afa71d72ff9aaff75a6810b87b486bc492fd752e4f77b07c41759ce4ef36b31
TERMUX_PKG_DEPENDS="libassuan, libbz2, libgcrypt, libgnutls, libgpg-error, libksba, libnpth, libsqlite, readline, pinentry, resolv-conf, zlib"
TERMUX_PKG_CONFLICTS="gnupg2 (<< 2.2.9-1), dirmngr (<< 2.2.17-1)"
TERMUX_PKG_REPLACES="gnupg2 (<< 2.2.9-1), dirmngr (<< 2.2.17-1)"
TERMUX_PKG_SUGGESTS="scdaemon"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-ldap
--enable-sqlite
--enable-tofu
ac_cv_path_YAT2M=$TERMUX_PKG_HOSTBUILD_DIR/bin/yat2m
"
# Remove non-english help files and man pages shipped with the gnupg (1) package:
TERMUX_PKG_RM_AFTER_INSTALL="share/gnupg/help.*.txt share/man/man1/gpg-zip.1 share/man/man7/gnupg.7"
TERMUX_PKG_HOSTBUILD=true

# The yat2m binary is available in the gpgrt-tools package, but let's just build
# it ourselves since Ubuntu is likely just ship a very old version
termux_step_host_build() {
	LIBGPG_ERROR_VERSION=$(. $TERMUX_SCRIPTDIR/packages/libgpg-error/build.sh; echo $TERMUX_PKG_VERSION)
	LIBGPG_ERROR_SRCURL=$(. $TERMUX_SCRIPTDIR/packages/libgpg-error/build.sh; echo $TERMUX_PKG_SRCURL)
	LIBGPG_ERROR_SHA256=$(. $TERMUX_SCRIPTDIR/packages/libgpg-error/build.sh; echo $TERMUX_PKG_SHA256)

	termux_download \
		$LIBGPG_ERROR_SRCURL \
		$TERMUX_PKG_CACHEDIR/libgpg-error-${LIBGPG_ERROR_VERSION}.tar.bz2 \
		$LIBGPG_ERROR_SHA256
	tar xf $TERMUX_PKG_CACHEDIR/libgpg-error-${LIBGPG_ERROR_VERSION}.tar.bz2
	mkdir bin
	gcc ./libgpg-error-${LIBGPG_ERROR_VERSION}/doc/yat2m.c -o bin/yat2m
}

termux_step_pre_configure() {
	CPPFLAGS+=" -Ddn_skipname=__dn_skipname"
}

termux_step_post_make_install() {
	cd $TERMUX_PREFIX/bin
	ln -sf gpg gpg2
}
