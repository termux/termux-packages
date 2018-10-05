TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com> @xeffyr"

TERMUX_PKG_HOMEPAGE=http://gpg-crypter.sourceforge.net/
TERMUX_PKG_DESCRIPTION="A graphical front-end to GnuPG(GPG) using the GTK3 toolkit and libgpgme"
TERMUX_PKG_VERSION=0.4.1
TERMUX_PKG_SRCURL=http://downloads.sourceforge.net/sourceforge/gpg-crypter/gpg-crypter-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=1f7e2b27bf4a27ecbb07bce9cd40d1c08477a3bd065ba7d1a75d1732e4bdc023
TERMUX_PKG_DEPENDS="atk, gdk-pixbuf, glib, gpgme, gtk3, libandroid-shmem, libassuan, libcairo-x, libgpg-error, pango-x"
TERMUX_PKG_RM_AFTER_INSTALL="lib/locale"

termux_step_pre_configure() {
    export LIBS="-landroid-shmem"
}
