TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/wget/
TERMUX_PKG_DESCRIPTION="Commandline tool for retrieving files using HTTP, HTTPS and FTP"
TERMUX_PKG_VERSION=1.19.1
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/wget/wget-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=0c950b9671881222a4d385b013c9604e98a8025d1988529dfca0e93617744cd2
TERMUX_PKG_DEPENDS="pcre, openssl, libuuid, libandroid-support"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-ssl=openssl --disable-iri"
