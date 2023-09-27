TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/libgcrypt/
TERMUX_PKG_DESCRIPTION="General purpose cryptographic library based on the code from GnuPG"
TERMUX_PKG_LICENSE="GPL-2.0, LGPL-2.1, BSD 3-Clause, MIT, Public Domain"
TERMUX_PKG_LICENSE_FILE="COPYING, COPYING.LIB, LICENSES"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.10.2
TERMUX_PKG_SRCURL=https://www.gnupg.org/ftp/gcrypt/libgcrypt/libgcrypt-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=3b9c02a004b68c256add99701de00b383accccf37177e0d6c58289664cce0c03
TERMUX_PKG_DEPENDS="libgpg-error"
TERMUX_PKG_BUILD_DEPENDS="binutils-cross"
TERMUX_PKG_BREAKS="libgcrypt-dev"
TERMUX_PKG_REPLACES="libgcrypt-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-jent-support
"

termux_step_pre_configure() {
	autoreconf -fi

	termux_setup_no_integrated_as
	if [ "$TERMUX_ARCH" = arm ]; then
		# See http://marc.info/?l=gnupg-devel&m=139136972631909&w=3
		CFLAGS+=" -mno-unaligned-access"
		# Avoid text relocations:
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" gcry_cv_gcc_inline_asm_neon=no"
	elif [ "$TERMUX_ARCH" = i686 ] || [ "$TERMUX_ARCH" = x86_64 ]; then
		# Fix i686 android build, also in https://bugzilla.gnome.org/show_bug.cgi?id=724050
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --disable-asm"
	fi
}
