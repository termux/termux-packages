TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/wget/
TERMUX_PKG_DESCRIPTION="Commandline tool for retrieving files using HTTP, HTTPS and FTP"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.21.2
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/wget/wget-${TERMUX_PKG_VERSION}.tar.lz
TERMUX_PKG_SHA256=1727a330a86acacb3e57615ce268f5f29978bf7adec4abe6a30d370207bc91b3
TERMUX_PKG_DEPENDS="libiconv, pcre2, openssl, libuuid, libandroid-support, libunistring, zlib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_func_getpass=yes
ac_cv_header_spawn_h=no
--disable-iri
--with-ssl=openssl
"
