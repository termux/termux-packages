TERMUX_PKG_HOMEPAGE=https://gitlab.com/gnuwget/wget2
TERMUX_PKG_DESCRIPTION="The successor of GNU Wget, a file and recursive website downloader"
TERMUX_PKG_LICENSE="GPL-3.0, LGPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.3.0"
TERMUX_PKG_SRCURL="https://mirrors.kernel.org/gnu/wget/wget2-${TERMUX_PKG_VERSION}.tar.lz"
TERMUX_PKG_SHA256=becf0a06fcfb7760be88db4b29048b31cb7c789e33dc571475071144b0f2caf4
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="brotli, gpgme, libandroid-glob, openssl, libiconv, libidn2, libnghttp2, pcre2, zlib, zstd"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_header_spawn_h=no
--with-ssl=openssl
"

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-glob"
	CFLAGS+=" -DNO_INLINE_GETPASS=1"
}
