TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/wget/
TERMUX_PKG_DESCRIPTION="Commandline tool for retrieving files using HTTP, HTTPS and FTP"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.21.3
TERMUX_PKG_REVISION=5
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/wget/wget-${TERMUX_PKG_VERSION}.tar.lz
TERMUX_PKG_SHA256=dbd2fb5e47149d4752d0eaa0dac68cc49cf20d46df4f8e326ffc8f18b2af4ea5
TERMUX_PKG_DEPENDS="libiconv, pcre2, openssl, libuuid (>> 2.38.1), libandroid-support, libandroid-spawn, zlib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_func_getpass=yes
ac_cv_libunistring=no
--disable-iri
--with-ssl=openssl
--with-included-libunistring=no
--without-libunistring-prefix
"

termux_step_pre_configure() {
	export LDFLAGS+=" -landroid-spawn"
}
