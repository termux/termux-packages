TERMUX_PKG_HOMEPAGE=https://tinyproxy.github.io/
TERMUX_PKG_DESCRIPTION="Light-weight HTTP proxy daemon for POSIX operating systems"
TERMUX_PKG_VERSION=1.8.4
TERMUX_PKG_SHA256=a41f4ddf0243fc517469cf444c8400e1d2edc909794acda7839f1d644e8a5000
TERMUX_PKG_SRCURL=https://github.com/tinyproxy/tinyproxy/releases/download/${TERMUX_PKG_VERSION}/tinyproxy-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-regexcheck"

termux_step_pre_configure() {
	LDFLAGS+=" -llog"
}

termux_step_post_massage() {
	mkdir -p $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/var/log/$TERMUX_PKG_NAME
	mkdir -p $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/var/run/$TERMUX_PKG_NAME
	find $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/var -exec chmod -f u+w,g-rwx,o-rwx \{\} \;
}
