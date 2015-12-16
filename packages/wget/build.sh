TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/wget/
TERMUX_PKG_DESCRIPTION="Commandline tool for retrieving files using HTTP, HTTPS and FTP"
TERMUX_PKG_VERSION=1.17.1
TERMUX_PKG_BUILD_REVISION=1
TERMUX_PKG_SRCURL=http://ftp.gnu.org/gnu/wget/wget-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_DEPENDS="pcre, openssl, libuuid"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-ssl=openssl --disable-iri"
