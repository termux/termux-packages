TERMUX_PKG_HOMEPAGE=https://termshark.io
TERMUX_PKG_DESCRIPTION="A terminal UI for tshark, inspired by Wireshark"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_VERSION=2.0.2
TERMUX_PKG_SHA256=36e45dfeb97f89379bda5be6bfe69c46e5c4211674120977e7b0033f5d90321a
TERMUX_PKG_SRCURL=https://github.com/gcla/termshark/archive/v${TERMUX_PKG_VERSION}.tar.gz

TERMUX_PKG_DEPENDS="tshark"

termux_step_make() {
	termux_setup_golang

	export GOPATH=$TERMUX_PKG_BUILDDIR
	export GO111MODULE=on

	cd $TERMUX_PKG_BUILDDIR
	go get -d -v github.com/gcla/termshark/v2/cmd/termshark@e185fa59d87c06fe1bafb83ce6dc15591434ccc8
	go install github.com/gcla/termshark/v2/cmd/termshark
}

termux_step_make_install() {
	cd $TERMUX_PKG_BUILDDIR
	install -Dm700 bin/android_${GOARCH}/termshark $TERMUX_PREFIX/bin/termshark
}
