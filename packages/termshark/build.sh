TERMUX_PKG_HOMEPAGE=https://termshark.io
TERMUX_PKG_DESCRIPTION="A terminal UI for tshark, inspired by Wireshark"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_VERSION=1.0.0
TERMUX_PKG_SHA256=669bba0e8dd7df54ade6321a5c7d2ec20563ffd777f7b3b0394a11f88da64698
TERMUX_PKG_SRCURL=https://github.com/gcla/termshark/archive/v${TERMUX_PKG_VERSION}.tar.gz

TERMUX_PKG_DEPENDS="wireshark"

termux_step_make() {
	termux_setup_golang

	export GOPATH=$TERMUX_PKG_BUILDDIR
	export GO111MODULE=on

	cd $TERMUX_PKG_BUILDDIR
	go get -d -v github.com/gcla/termshark@v${TERMUX_PKG_VERSION}
	go build -ldflags="-X github.com/gcla/termshark.Version=${TERMUX_PKG_VERSION}" github.com/gcla/termshark/cmd/termshark
}

termux_step_make_install() {
	cd $TERMUX_PKG_BUILDDIR
	install -Dm700 termshark $TERMUX_PREFIX/bin/termshark
}
