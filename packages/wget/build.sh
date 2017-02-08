TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/wget/
TERMUX_PKG_DESCRIPTION="Commandline tool for retrieving files using HTTP, HTTPS and FTP"
TERMUX_PKG_VERSION=1.19
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/wget/wget-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=0f1157bbf4daae19f3e1ddb70c6ccb2067feb834a6aa23c9d9daa7f048606384
TERMUX_PKG_DEPENDS="pcre, openssl, libuuid, libandroid-support"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-ssl=openssl --disable-iri"
