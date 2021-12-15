TERMUX_PKG_HOMEPAGE=https://github.com/gogakoreli/snake
TERMUX_PKG_DESCRIPTION="Eat as much as you want while avoiding walls."
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Tipz Team @TipzTeam"
TERMUX_PKG_VERSION=2017.06.09
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/gogakoreli/snake/archive/4ccdf33feaa0a24578f3ddcf8137e52c93444f15.tar.gz
TERMUX_PKG_SHA256=f99212d620ac593272a0489a7d83b44f92a39bcd11c299c728ea08f1eee656a6
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make_install() {
	install -Dm755 -t $TERMUX_PREFIX/bin/ snake
}

termux_step_install_license() {
	install -Dm644 -t $TERMUX_PREFIX/share/doc/snake/ \
		$TERMUX_PKG_BUILDER_DIR/LICENSE
}
