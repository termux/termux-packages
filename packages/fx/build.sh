TERMUX_PKG_HOMEPAGE="https://github.com/antonmedv/fx"
TERMUX_PKG_DESCRIPTION="Interactive JSON viewer on your terminal"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@flosnvjx"
TERMUX_PKG_VERSION="39.0.4"
TERMUX_PKG_SRCURL="https://github.com/antonmedv/fx/archive/refs/tags/$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=e28b091c28a1f3408795337c6d5e01aa2162ebb75d4d6d950acb00911ffb5305
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make() {
	termux_setup_golang
	mkdir bin
	go build -o ./bin -trimpath
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin bin/*
}
