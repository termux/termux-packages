TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/wget/
TERMUX_PKG_DESCRIPTION="Commandline tool for retrieving files using HTTP, HTTPS and FTP"
TERMUX_PKG_VERSION=1.19.2
TERMUX_PKG_REVISION=1
TERMUX_PKG_SHA256=d59a745ad2c522970660bb30d38601f9457b151b322e01fa20a5a0da0f55df07
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/wget/wget-${TERMUX_PKG_VERSION}.tar.lz
TERMUX_PKG_DEPENDS="pcre, openssl, libuuid, libandroid-support, libunistring"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-ssl=openssl --disable-iri"
