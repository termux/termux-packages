TERMUX_PKG_HOMEPAGE=https://termshark.io
TERMUX_PKG_DESCRIPTION="A terminal UI for tshark, inspired by Wireshark"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.3.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SHA256=8e2a22534773b1ab0ce4327e929bbbe413d3695bab2d55c985d1f61961698610
TERMUX_PKG_SRCURL=https://github.com/gcla/termshark/archive/v${TERMUX_PKG_VERSION}.tar.gz

TERMUX_PKG_DEPENDS="tshark"

termux_step_make() {
	termux_setup_golang

	export GOPATH=$TERMUX_PKG_BUILDDIR
	export GO111MODULE=on

	cd $TERMUX_PKG_SRCDIR
	git clone https://github.com/gcla/termshark
	cd termshark
	git checkout v2.3.0
	go install ./...
}

termux_step_make_install() {
	cd $TERMUX_PKG_BUILDDIR
	install -Dm700 bin/android_${GOARCH}/termshark $TERMUX_PREFIX/bin/termshark
}
