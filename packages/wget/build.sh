TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/wget/
TERMUX_PKG_DESCRIPTION="Commandline tool for retrieving files using HTTP, HTTPS and FTP"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.21.4
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/wget/wget-${TERMUX_PKG_VERSION}.tar.lz
TERMUX_PKG_SHA256=3683619a5f50edcbccb1720a79006fa37bf9b9a255a8c5b48048bc3c7a874bd9
TERMUX_PKG_DEPENDS="libandroid-support, libiconv, libidn2, libuuid, openssl, pcre2, zlib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_func_getpass=yes
ac_cv_libunistring=no
--enable-iri
--with-ssl=openssl
--with-included-libunistring=no
--without-libunistring-prefix
"
