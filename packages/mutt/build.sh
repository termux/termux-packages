TERMUX_PKG_HOMEPAGE=http://www.mutt.org/
TERMUX_PKG_DESCRIPTION="Mail client with patches from neomutt"
TERMUX_PKG_VERSION=1.9.0
TERMUX_PKG_SRCURL=ftp://ftp.mutt.org/pub/mutt/mutt-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=ec6d7595d3a1f26ae9f565b5ba5ffee94f9b2dc0683b0014684f2dc874f9e2d4
TERMUX_PKG_DEPENDS="libandroid-support, ncurses, gdbm, openssl, libsasl, mime-support"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-smtp --enable-imap --enable-pop --with-mailpath=$TERMUX_PREFIX/var/mail --with-ssl --enable-compressed --without-idn --enable-hcache --with-sasl --enable-sidebar"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --with-exec-shell=$TERMUX_PREFIX/bin/sh"
# The mutt autoconf guesses no for working (v)snprintf and uses broken local versions - avoid that:
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" mutt_cv_c99_snprintf=yes mutt_cv_c99_vsnprintf=yes"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --disable-gpgme"
# TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --with-sasl"
# bin/{flea,muttbug}: File bug against mutt:
TERMUX_PKG_RM_AFTER_INSTALL="
bin/flea
bin/muttbug
share/man/man1/muttbug.1
share/man/man1/flea.1
etc/mime.types
"
TERMUX_PKG_CONFFILES="etc/Muttrc"

termux_step_post_configure () {
	# Build wants to run mutt_md5 and makedoc:
	gcc -DHAVE_STDINT_H -DMD5UTIL $TERMUX_PKG_SRCDIR/md5.c -o $TERMUX_PKG_BUILDDIR/mutt_md5
	gcc -DHAVE_STRERROR $TERMUX_PKG_SRCDIR/doc/makedoc.c -o $TERMUX_PKG_BUILDDIR/doc/makedoc
	touch -d "next hour" $TERMUX_PKG_BUILDDIR/mutt_md5 $TERMUX_PKG_BUILDDIR/doc/makedoc
}

termux_step_post_make_install () {
	cp $TERMUX_PKG_SRCDIR/doc/mutt.man $TERMUX_PREFIX/share/man/man1/mutt.1.man
	mkdir -p $TERMUX_PREFIX/share/examples/mutt/
	cp $TERMUX_PKG_BUILDER_DIR/gpg{,2}.rc $TERMUX_PREFIX/share/examples/mutt/
	mv $TERMUX_PREFIX/etc/mime.types.dist $TERMUX_PREFIX/etc/mime.types
	mv $TERMUX_PREFIX/etc/Muttrc.dist $TERMUX_PREFIX/etc/Muttrc
}
