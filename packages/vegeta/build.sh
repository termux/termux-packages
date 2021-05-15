TERMUX_PKG_HOMEPAGE=https://github.com/tsenart/vegeta
TERMUX_PKG_DESCRIPTION="HTTP load testing tool"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="12.10.0"
TERMUX_PKG_SRCURL=https://github.com/tsenart/vegeta/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=4ea951258d041887a2cbdd0b87bf87023c304033d804eca1bfa0a1091b3124c6
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make() {
	termux_setup_golang

	export GOPATH=$TERMUX_PKG_BUILDDIR
	mkdir -p "$GOPATH"/src/github.com/tsenart
	ln -sf "$TERMUX_PKG_SRCDIR" "$GOPATH"/src/github.com/tsenart/vegeta

	cd "$GOPATH"/src/github.com/tsenart/vegeta
	go build
}

termux_step_make_install() {
	install -Dm700 \
		"$GOPATH"/src/github.com/tsenart/vegeta/vegeta \
		"$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX"/bin/vegeta
}
