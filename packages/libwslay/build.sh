TERMUX_PKG_HOMEPAGE=https://github.com/tatsuhiro-t/wslay
TERMUX_PKG_DESCRIPTION="WebSocket library"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.1.1
TERMUX_PKG_SRCURL=https://github.com/tatsuhiro-t/wslay/releases/download/release-$TERMUX_PKG_VERSION/wslay-$TERMUX_PKG_VERSION.tar.bz2
TERMUX_PKG_SHA256=6a3e2ceba52424b14521a7469a35bfd781b018ca93c300b71df3618273af6ed9
TERMUX_PKG_PROVIDES="wslay"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-static
"

termux_step_pre_configure() {
	autoreconf -fi
}

termux_step_post_massage() {
	find lib -name '*.la' -delete
}
