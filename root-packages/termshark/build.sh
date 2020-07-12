TERMUX_PKG_HOMEPAGE=https://termshark.io
TERMUX_PKG_DESCRIPTION="A terminal UI for tshark, inspired by Wireshark"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_VERSION=2.1.1
TERMUX_PKG_REVISION=1
TERMUX_PKG_SHA256=c02a21e0a61b791b1287b85acc33834ccd3bb4efb40be52e5a74d2b989d51416
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
