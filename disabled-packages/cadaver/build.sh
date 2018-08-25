# Status: Does not work with openssl 1.1 or later.
TERMUX_PKG_HOMEPAGE=http://www.webdav.org/cadaver/
TERMUX_PKG_DESCRIPTION="cadaver is a command-line WebDAV client for Unix"
TERMUX_PKG_VERSION=0.23.3
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://fossies.org/linux/www/old/cadaver-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=123772d7d33f06a76742dba874b1c444423b52ad3a7bbb87559616ec78b9ae5e
TERMUX_PKG_DEPENDS="openssl, libxml2, ncurses, readline"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--with-libxml2
--without-gssapi
--with-ssl=openssl
"

termux_step_pre_configure() {
    export ac_cv_func_setlocale=no
}
