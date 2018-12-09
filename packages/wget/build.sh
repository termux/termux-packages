TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/wget/
TERMUX_PKG_DESCRIPTION="Commandline tool for retrieving files using HTTP, HTTPS and FTP"
TERMUX_PKG_VERSION=1.20
TERMUX_PKG_SHA256=b0b80f565ac27f5e56c847431c75b4f8fcb31af9dad2bf5ce947d89651f3681e
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/wget/wget-${TERMUX_PKG_VERSION}.tar.lz
TERMUX_PKG_DEPENDS="pcre2, openssl, libuuid, libandroid-support, libunistring"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_func_getpass=yes
--disable-iri
--with-ssl=openssl
"
