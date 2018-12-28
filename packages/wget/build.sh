TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/wget/
TERMUX_PKG_DESCRIPTION="Commandline tool for retrieving files using HTTP, HTTPS and FTP"
TERMUX_PKG_VERSION=1.20.1
TERMUX_PKG_SHA256=0f63e84dd23dc53ab3ab6f483c3afff8301e54c165783f772101cdd9b1c64928
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/wget/wget-${TERMUX_PKG_VERSION}.tar.lz
TERMUX_PKG_DEPENDS="pcre2, openssl, libuuid, libandroid-support, libunistring"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_func_getpass=yes
--disable-iri
--with-ssl=openssl
"
