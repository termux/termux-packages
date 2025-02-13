TERMUX_PKG_HOMEPAGE=https://www.gnupg.org/related_software/gpgme/
TERMUX_PKG_DESCRIPTION="Library designed to make access to GnuPG easier"
TERMUX_PKG_LICENSE="GPL-2.0, LGPL-2.1, MIT"
TERMUX_PKG_LICENSE_FILE="COPYING, COPYING.LESSER, LICENSES"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.24.2"
TERMUX_PKG_SRCURL=https://www.gnupg.org/ftp/gcrypt/gpgme/gpgme-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=e11b1a0e361777e9e55f48a03d89096e2abf08c63d84b7017cfe1dce06639581
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="gnupg (>= 2.2.9-1), libassuan, libgpg-error"
TERMUX_PKG_BREAKS="gpgme-dev"
TERMUX_PKG_REPLACES="gpgme-dev"
# Use "--disable-gpg-test" to avoid "No rule to make target `../../src/libgpgme-pthread.la":
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-gpg-test
--enable-languages=cpp
--with-gpg=$TERMUX_PREFIX/bin/gpg2
--without-g13
--without-gpgconf
--without-gpgsm
ac_cv_path_YAT2M=:
"

termux_step_pre_configure() {
	local _libgcc_file="$($CC -print-libgcc-file-name)"
	local _libgcc_path="$(dirname $_libgcc_file)"
	local _libgcc_name="$(basename $_libgcc_file)"
	LDFLAGS+=" -L$_libgcc_path -l:$_libgcc_name"
}
