TERMUX_PKG_HOMEPAGE=https://github.com/tsenart/vegeta
TERMUX_PKG_DESCRIPTION="HTTP load testing tool"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
TERMUX_PKG_VERSION=12.8.1
TERMUX_PKG_SRCURL=https://github.com/tsenart/vegeta/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=4fabf66f0137a5dde73c615330b8f163783b83bdfd8b06b365f1841c732b80ee

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
