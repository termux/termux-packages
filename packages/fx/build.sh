TERMUX_PKG_HOMEPAGE="https://github.com/antonmedv/fx"
TERMUX_PKG_DESCRIPTION="Interactive JSON viewer on your terminal"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@flosnvjx"
TERMUX_PKG_VERSION="40.0.0"
TERMUX_PKG_SRCURL="https://github.com/antonmedv/fx/archive/refs/tags/$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=92e5ade859952bc79a3c68492803ce0af25a7332c78c4a0e1914da302d88b478
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
