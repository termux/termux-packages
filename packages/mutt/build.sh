TERMUX_PKG_HOMEPAGE=http://www.mutt.org/
TERMUX_PKG_DESCRIPTION="Mail client with patches from neomutt"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=1.12.1
TERMUX_PKG_SRCURL=ftp://ftp.mutt.org/pub/mutt/mutt-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=01c565406ec4ffa85db90b45ece2260b25fac3646cc063bbc20a242c6ed4210c
TERMUX_PKG_DEPENDS="libandroid-support, ncurses, gdbm, openssl, libsasl, mime-support, zlib, libiconv"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
mutt_cv_c99_snprintf=yes
mutt_cv_c99_vsnprintf=yes
--disable-gpgme
--enable-compressed
--enable-hcache
--enable-imap
--enable-pop
--enable-sidebar
--enable-smtp
--with-exec-shell=$TERMUX_PREFIX/bin/sh
--with-mailpath=$TERMUX_PREFIX/var/mail
--without-idn
--with-sasl
--with-ssl
"

TERMUX_PKG_RM_AFTER_INSTALL="
bin/flea
bin/muttbug
share/man/man1/muttbug.1
share/man/man1/flea.1
etc/mime.types
"

TERMUX_PKG_CONFFILES="etc/Muttrc"

termux_step_post_configure() {
	# Build wants to run mutt_md5 and makedoc:
	gcc -DHAVE_STDINT_H -DMD5UTIL $TERMUX_PKG_SRCDIR/md5.c -o $TERMUX_PKG_BUILDDIR/mutt_md5
	gcc -DHAVE_STRERROR $TERMUX_PKG_SRCDIR/doc/makedoc.c -o $TERMUX_PKG_BUILDDIR/doc/makedoc
	touch -d "next hour" $TERMUX_PKG_BUILDDIR/mutt_md5 $TERMUX_PKG_BUILDDIR/doc/makedoc
}

termux_step_post_make_install() {
	cp $TERMUX_PKG_SRCDIR/doc/mutt.man $TERMUX_PREFIX/share/man/man1/mutt.1.man
	mkdir -p $TERMUX_PREFIX/share/examples/mutt/
	cp $TERMUX_PKG_SRCDIR/contrib/gpg.rc $TERMUX_PREFIX/share/examples/mutt/gpg.rc
	mv $TERMUX_PREFIX/etc/mime.types.dist $TERMUX_PREFIX/etc/mime.types
	mv $TERMUX_PREFIX/etc/Muttrc.dist $TERMUX_PREFIX/etc/Muttrc
}
