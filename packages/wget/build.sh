TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/wget/
TERMUX_PKG_DESCRIPTION="Commandline tool for retrieving files using HTTP, HTTPS and FTP"
TERMUX_PKG_VERSION=1.19.4
TERMUX_PKG_SHA256=2fc0ffb965a8dc8f1e4a89cbe834c0ae7b9c22f559ebafc84c7874ad1866559a
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/wget/wget-${TERMUX_PKG_VERSION}.tar.lz
TERMUX_PKG_DEPENDS="pcre, openssl, libuuid, libandroid-support, libunistring"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-ssl=openssl --disable-iri"
