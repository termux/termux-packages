TERMUX_PKG_VERSION=1.7.2
TERMUX_PKG_HOMEPAGE=http://www.gnu.org/software/libgcrypt/
TERMUX_PKG_DESCRIPTION="General purpose cryptographic library based on the code from GnuPG"
TERMUX_PKG_SRCURL=ftp://ftp.gnupg.org/gcrypt/libgcrypt/libgcrypt-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_DEPENDS="libgpg-error"
# configure tries to detect pthreads by linking with -lpthread, which does not exist on Android:
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_cv_lib_pthread_pthread_create=yes"
LDFLAGS="$LDFLAGS -llog" # libgcrypt uses syslog, which we redirect to android logging

termux_step_pre_configure () {
	if [ $TERMUX_ARCH = "arm" ]; then
		# See http://marc.info/?l=gnupg-devel&m=139136972631909&w=3
		CFLAGS+=" -mno-unaligned-access"
                # Avoid text relocations:
                TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" gcry_cv_gcc_inline_asm_neon=no"
	fi
	if [ $TERMUX_ARCH = "i686" -o $TERMUX_ARCH = "x86_64" ]; then
		# Fix i686 android build, also in https://bugzilla.gnome.org/show_bug.cgi?id=724050
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --disable-asm"
	fi
}
