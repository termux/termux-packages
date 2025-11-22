TERMUX_PKG_HOMEPAGE=http://www.mutt.org/
TERMUX_PKG_DESCRIPTION="Mail client with patches from neomutt"
TERMUX_PKG_LICENSE="GPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.2.16"
TERMUX_PKG_SRCURL=ftp://ftp.mutt.org/pub/mutt/mutt-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=1d3109a743ad8b25eef97109b2bdb465db7837d0a8d211cd388be1b6faac3f32
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libandroid-support, ncurses, gdbm, openssl, libsasl, media-types, zlib, libiconv"
TERMUX_PKG_BUILD_IN_SRC=true

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
mutt_cv_c99_snprintf=yes
mutt_cv_c99_vsnprintf=yes
--disable-gpgme
--enable-compressed
--enable-debug
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

# fget{c,s}_unlocked were added in API level 28.
# AC_CHECK_FUNCS(fget{c,s}_unlocked) finds them in libc, even though
# it is not defined in stdio.h, so we need to override the check or
# else compilation on device fails
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+="
ac_cv_func_fgetc_unlocked=no
ac_cv_func_fgets_unlocked=no
"

if $TERMUX_DEBUG_BUILD; then
	export TERMUX_PKG_EXTRA_CONFIGURE_ARGS+="--enable-debug"
fi

TERMUX_PKG_RM_AFTER_INSTALL="
bin/flea
bin/muttbug
share/man/man1/muttbug.1
share/man/man1/flea.1
etc/mime.types.dist
"

TERMUX_PKG_CONFFILES="etc/Muttrc"

termux_step_post_configure() {
	# Build wants to run mutt_md5:
	gcc -DHAVE_STDINT_H -DMD5UTIL $TERMUX_PKG_SRCDIR/md5.c -o $TERMUX_PKG_BUILDDIR/mutt_md5
	touch -d "next hour" $TERMUX_PKG_BUILDDIR/mutt_md5
}

termux_step_post_make_install() {
	cp doc/mutt.man $TERMUX_PREFIX/share/man/man1/mutt.1.man
	mkdir -p $TERMUX_PREFIX/share/examples/mutt/
	cp contrib/gpg.rc $TERMUX_PREFIX/share/examples/mutt/
}
