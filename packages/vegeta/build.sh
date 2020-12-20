TERMUX_PKG_HOMEPAGE=https://github.com/tsenart/vegeta
TERMUX_PKG_DESCRIPTION="HTTP load testing tool"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=12.8.4
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/tsenart/vegeta/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=418249d07f04da0a587df45abe34705166de9e54a836e27e387c719ebab3e357

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
		"$TERMUX_PREFIX"/bin/vegeta
}
