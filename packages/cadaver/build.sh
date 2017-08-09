TERMUX_PKG_HOMEPAGE=http://www.webdav.org/cadaver/
TERMUX_PKG_DESCRIPTION="cadaver is a command-line WebDAV client for Unix"
TERMUX_PKG_VERSION=0.23.3
TERMUX_PKG_SRCURL=http://www.webdav.org/cadaver/cadaver-0.23.3.tar.gz
TERMUX_PKG_SHA256=fd4ce68a3230ba459a92bcb747fc6afa91e46d803c1d5ffe964b661793c13fca
TERMUX_PKG_DEPENDS="libgcrypt, libgnutls, libxml2, ncurses, readline"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--with-libxml2
--without-gssapi
"

termux_step_pre_configure() {
    export ac_cv_func_setlocale=no
}
