TERMUX_PKG_HOMEPAGE=https://github.com/pocketbase/pocketbase
TERMUX_PKG_DESCRIPTION="An open source Go backend"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.14.1"
TERMUX_PKG_SRCURL="https://github.com/pocketbase/pocketbase/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=72c48906b47e9e691760cc96b368c48e92c1b91defb93c8cf22d0774c8e41d67
TERMUX_PKG_DEPENDS="resolv-conf"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_ENABLE_CLANG16_PORTING=false

termux_step_make() {
	termux_setup_golang

	mkdir ./gopath
	export GOPATH="$PWD/gopath"

	cd $TERMUX_PKG_SRCDIR/examples/base

	export GOBUILD=CGO_ENABLED=0

	go build \
		-trimpath \
		-o "pocketbase.bin" \
		main.go
}

termux_step_make_install() {
	install -m700 examples/base/pocketbase.bin "${TERMUX_PREFIX}"/bin/pocketbase
}
