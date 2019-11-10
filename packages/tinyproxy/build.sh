TERMUX_PKG_HOMEPAGE=https://tinyproxy.github.io/
TERMUX_PKG_DESCRIPTION="Light-weight HTTP proxy daemon for POSIX operating systems"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=1.10.0
TERMUX_PKG_SHA256=59be87689c415ba0d9c9bc6babbdd3df3b372d60b21e526b118d722dbc995682
TERMUX_PKG_SRCURL=https://github.com/tinyproxy/tinyproxy/releases/download/${TERMUX_PKG_VERSION}/tinyproxy-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-regexcheck"

termux_step_pre_configure() {
	export LIBS="-llog"
}

termux_step_post_massage() {
	mkdir -p $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/var/log/$TERMUX_PKG_NAME
	mkdir -p $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/var/run/$TERMUX_PKG_NAME
	find $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/var -exec chmod -f u+w,g-rwx,o-rwx \{\} \;
}
