TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/wget/
TERMUX_PKG_DESCRIPTION="Commandline tool for retrieving files using HTTP, HTTPS and FTP"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.21
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/wget/wget-${TERMUX_PKG_VERSION}.tar.lz
TERMUX_PKG_SHA256=87ae105e76e5b550e03e009ba94341143c66623a5ecbba047f6ef850608b6596
TERMUX_PKG_DEPENDS="libiconv, pcre2, openssl, libuuid, libandroid-support, libunistring, zlib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_func_getpass=yes
ac_cv_header_spawn_h=no
--disable-iri
--with-ssl=openssl
"
