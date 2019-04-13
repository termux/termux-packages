TERMUX_PKG_HOMEPAGE=https://www.dovecot.org
TERMUX_PKG_DESCRIPTION="Secure IMAP and POP3 email server"
TERMUX_PKG_VERSION=2.2.31
TERMUX_PKG_SRCURL=https://www.dovecot.org/releases/2.2/dovecot-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=034be40907748128d65088a4f59789b2f99ae7b33a88974eae0b6a68ece376a1
TERMUX_PKG_MAINTAINER="Vishal Biswas @vishalbiswas"
TERMUX_PKG_DEPENDS="openssl, libcrypt"
# turning on icu gives undefined reference to __cxa_call_unexpected
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--with-zlib
--with-ssl=openssl
--with-ssldir=$TERMUX_PREFIX/etc/tls
--without-icu
--without-shadow
i_cv_epoll_works=yes
i_cv_posix_fallocate_works=yes
i_cv_signed_size_t=no
i_cv_gmtime_max_time_t=40
i_cv_signed_time_t=yes
i_cv_mmap_plays_with_write=yes
i_cv_fd_passing=yes
i_cv_c99_vsnprintf=yes
lib_cv_va_copy=yes
lib_cv___va_copy=yes
"

termux_step_pre_configure() {
	LDFLAGS="$LDFLAGS -llog"

	for i in $(find $TERMUX_PKG_SRCDIR/src/director -type f); do sed 's|\bstruct user\b|struct usertest|g' -i $i; done

	if [ "$TERMUX_ARCH" == "aarch64" ]; then
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+="lib_cv_va_val_copy=yes"
	else
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+="lib_cv_va_val_copy=no"
	fi
}

termux_step_post_make_install() {
	for binary in doveadm doveconf; do
		mv $TERMUX_PREFIX/bin/$binary $TERMUX_PREFIX/libexec/dovecot/$binary
		cat > $TERMUX_PREFIX/bin/$binary <<HERE
#!$TERMUX_PREFIX/bin/sh
export LD_LIBRARY_PATH=$TERMUX_PREFIX/lib/dovecot:\$LD_LIBRARY_PATH
exec $TERMUX_PREFIX/libexec/dovecot/$binary $@
HERE
		chmod u+x $TERMUX_PREFIX/bin/$binary
	done
}
