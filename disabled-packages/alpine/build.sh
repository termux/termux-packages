TERMUX_PKG_HOMEPAGE=http://patches.freeiz.com
TERMUX_PKG_DESCRIPTION="Fast, easy to use email client"
TERMUX_PKG_VERSION=2.21
TERMUX_PKG_SRCURL=http://alpine.freeiz.com/alpine/release/src/alpine-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_DEPENDS="libcrypt, ncurses, openssl"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-debug
--with-c-client-target=lnx
--without-krb5
--without-ldap
--without-pthread
--without-tcl
--with-system-pinerc=${TERMUX_PREFIX}/etc/pine.conf
"
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_SHA256=6030b6881b8168546756ab3a5e43628d8d564539b0476578e287775573a77438

termux_step_post_extract_package() {
	# requires installing autopoint default docker image doesn't have that installed as yet.
	# adding huge patchsets to termux-packages repo is not optimal so we do it this way for now.
	local file="$TERMUX_PKG_CACHEDIR/maildir.patch.gz"
	termux_download \
		http://alpine.freeiz.com/alpine/patches/alpine-${TERMUX_PKG_VERSION}/maildir.patch.gz \
		"$file" \
		1229ea9ec4e150dda1d2da866730a777148874e4667c54cd2c488101b5db8099
	gunzip -c $file | patch -s -p1
}

termux_step_pre_configure () {
	export TCC=$CC
	export TRANLIB=$RANLIB
	export SPELLPROG=${TERMUX_PREFIX}/bin/hunspell
	export alpine_SSLVERSION=old
	export TPATH=$PATH

	LDFLAGS+=" -lcrypt -llog"

	cp $TERMUX_PKG_BUILDER_DIR/getpass.c $TERMUX_PKG_SRCDIR/include/
	cp $TERMUX_PKG_BUILDER_DIR/getpass.h $TERMUX_PKG_SRCDIR/include/
	cp $TERMUX_PKG_BUILDER_DIR/pine.conf $TERMUX_PREFIX/etc/pine.conf

	touch $TERMUX_PKG_SRCDIR/imap/lnxok
}

termux_step_post_configure() {
	cd pith
	$CC_FOR_BUILD help_c_gen.c -o help_c_gen
	$CC_FOR_BUILD help_h_gen.c -o help_h_gen
	touch -d "next hour" help_c_gen help_h_gen
}

