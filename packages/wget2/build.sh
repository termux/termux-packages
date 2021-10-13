TERMUX_PKG_HOMEPAGE=https://gitlab.com/gnuwget/wget2
TERMUX_PKG_DESCRIPTION="The successor of GNU Wget, a file and recursive website downloader"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.99.2
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/wget/wget2-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=cbc48f55fa22ed2acbccf032c208c133cc59c7432cda8518a4992eb5882b6563
TERMUX_PKG_DEPENDS="gpgme, libandroid-glob, libassuan, libgnutls, libgpg-error, pcre2"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_header_spawn_h=no
-with-openssl=no
--with-ssl=gnutls
"

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-glob"
	CFLAGS+=" -DNO_INLINE_GETPASS=1"
}
