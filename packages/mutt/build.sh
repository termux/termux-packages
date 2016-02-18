TERMUX_PKG_HOMEPAGE=http://www.mutt.org/
TERMUX_PKG_DESCRIPTION="Mail client"
TERMUX_PKG_VERSION=1.5.24
TERMUX_PKG_BUILD_REVISION=2
TERMUX_PKG_SRCURL=https://bitbucket.org/mutt/mutt/downloads/mutt-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="libandroid-support, ncurses, gdbm, openssl, libsasl"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-smtp --enable-imap --enable-pop --with-mailpath=$TERMUX_PREFIX/var/mail --with-ssl --enable-compressed --without-idn --enable-hcache --with-sasl"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --with-exec-shell=$TERMUX_PREFIX/bin/sh"
# The mutt autoconf guesses no for working (v)snprintf and uses broken local versions - avoid that:
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" mutt_cv_c99_snprintf=yes mutt_cv_c99_vsnprintf=yes"
# TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --with-sasl"
# bin/{flea,muttbug}: File bug against mutt:
TERMUX_PKG_RM_AFTER_INSTALL="bin/flea bin/muttbug"

termux_step_post_configure () {
	# Build wants to run mutt_md5 at build time:
	gcc -D'uint32_t=unsigned int' -DMD5UTIL $TERMUX_PKG_SRCDIR/md5.c -o $TERMUX_PKG_BUILDDIR/mutt_md5
	$TERMUX_TOUCH -d "next hour" $TERMUX_PKG_BUILDDIR/mutt_md5
}

termux_step_post_make_install () {
        cp $TERMUX_PKG_SRCDIR/doc/mutt.man $TERMUX_PREFIX/share/man/man1/mutt.1.man
}
