TERMUX_PKG_HOMEPAGE=https://github.com/mongodb/mongo-tools
TERMUX_PKG_DESCRIPTION="MongoDB cli tools"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@medzikuser"
TERMUX_PKG_VERSION=100.5.1
TERMUX_PKG_SRCURL=https://github.com/mongodb/mongo-tools/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=04441784c364caf6d2603307c93c21c3b55808d0a3efae00bd34b4edf37e492d

termux_step_make() {
	termux_setup_golang

	export GOPATH=$TERMUX_PKG_BUILDDIR

	cd $TERMUX_PKG_SRCDIR

	go run build.go build
}

termux_step_make_install() {
	ls $TERMUX_PKG_SRCDIR/bin $TERMUX_PKG_SRCDIR
	install -Dm700 -t $TERMUX_PREFIX/bin $TERMUX_PKG_SRCDIR/bin/*
}
