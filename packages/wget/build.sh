TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/wget/
TERMUX_PKG_DESCRIPTION="Commandline tool for retrieving files using HTTP, HTTPS and FTP"
TERMUX_PKG_VERSION=1.19.2
TERMUX_PKG_SRCURL=http://mirrors.kernel.org/gnu/wget/wget-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=4f4a673b6d466efa50fbfba796bd84a46ae24e370fa562ede5b21ab53c11a920
TERMUX_PKG_DEPENDS="pcre, openssl, libuuid, libandroid-support"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-ssl=openssl --disable-iri"
