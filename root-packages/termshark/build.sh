TERMUX_PKG_HOMEPAGE=https://termshark.io
TERMUX_PKG_DESCRIPTION="A terminal UI for tshark, inspired by Wireshark"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.4.0
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=git+https://github.com/gcla/termshark
TERMUX_PKG_DEPENDS="tshark"

termux_step_make() {
	termux_setup_golang

	export GOPATH=$TERMUX_PKG_BUILDDIR
	export GO111MODULE=on

	cd $TERMUX_PKG_SRCDIR
	go install ./...
}

termux_step_make_install() {
	install -Dm700 bin/android_${GOARCH}/termshark $TERMUX_PREFIX/bin/termshark
}
