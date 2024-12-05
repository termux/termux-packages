TERMUX_PKG_HOMEPAGE=https://gitlab.com/gnuwget/wget2
TERMUX_PKG_DESCRIPTION="The successor of GNU Wget, a file and recursive website downloader"
TERMUX_PKG_LICENSE="GPL-3.0, LGPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.2.0"
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/wget/wget2-${TERMUX_PKG_VERSION}.tar.lz
TERMUX_PKG_SHA256=ffa5e49db90c9ddc0c830b66e473630c679b1b0a26a53d24981d4f0efa1c90b6
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="brotli, gpgme, libandroid-glob, libgnutls, libiconv, libidn2, libnghttp2, pcre2, zlib, zstd"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_header_spawn_h=no
-with-openssl=no
--with-ssl=gnutls
"

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-glob"
	CFLAGS+=" -DNO_INLINE_GETPASS=1"
}
