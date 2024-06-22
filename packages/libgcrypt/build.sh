TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/libgcrypt/
TERMUX_PKG_DESCRIPTION="General purpose cryptographic library based on the code from GnuPG"
TERMUX_PKG_LICENSE="GPL-2.0, LGPL-2.1, BSD 3-Clause, MIT, Public Domain"
TERMUX_PKG_LICENSE_FILE="COPYING, COPYING.LIB, LICENSES"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.10.3
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://www.gnupg.org/ftp/gcrypt/libgcrypt/libgcrypt-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=8b0870897ac5ac67ded568dcfadf45969cfa8a6beb0fd60af2a9eadc2a3272aa
TERMUX_PKG_DEPENDS="libgpg-error"
TERMUX_PKG_BREAKS="libgcrypt-dev"
TERMUX_PKG_REPLACES="libgcrypt-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-jent-support
"

termux_step_post_get_source() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION=20

	local a
	for a in LT_CURRENT LT_AGE; do
		local _${a}=$(sed -En 's/^LIBGCRYPT_'"${a}"'=([0-9]+).*/\1/p' \
				configure.ac)
	done

	local v=$(( _LT_CURRENT - _LT_AGE ))
	if [ ! "${_LT_CURRENT}" ] || [ "${v}" != "${_SOVERSION}" ]; then
		termux_error_exit "SOVERSION guard check failed."
	fi
}

termux_step_pre_configure() {
	autoreconf -fi

	if [ "$TERMUX_ARCH" = arm ]; then
		# See http://marc.info/?l=gnupg-devel&m=139136972631909&w=3
		CFLAGS+=" -mno-unaligned-access"
		# Avoid text relocations:
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" gcry_cv_gcc_inline_asm_neon=no"
	elif [ "$TERMUX_ARCH" = i686 ] || [ "$TERMUX_ARCH" = x86_64 ]; then
		# Fix i686 android build, also in https://bugzilla.gnome.org/show_bug.cgi?id=724050
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --disable-asm"
	fi

	# Fix build with lld 17, for more information, see the following links:
	# https://github.com/termux/termux-packages/issues/18761#issuecomment-1868896237
	# https://github.com/termux/termux-packages/issues/18810
	LDFLAGS+=" -Wl,--undefined-version"
}
