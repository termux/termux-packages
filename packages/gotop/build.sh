TERMUX_PKG_HOMEPAGE=https://github.com/xxxserxxx/gotop
TERMUX_PKG_DESCRIPTION="A terminal based graphical activity monitor inspired by gtop and vtop"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@medzikuser"
TERMUX_PKG_VERSION="4.2.0"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/xxxserxxx/gotop/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=e9d9041903acb6bd3ffe94e0a02e69eea53f1128274da1bfe00fe44331ccceb1
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make_install() {
	termux_setup_golang

	export GOPATH=$TERMUX_PKG_BUILDDIR

	cd $TERMUX_PKG_SRCDIR

	go build -o gotop \
	    -ldflags "-X main.Version=v${TERMUX_PKG_VERSION} -X main.BuildDate=$(date +%Y%m%dT%H%M%S)" \
	    ./cmd/gotop

	install -Dm700 -t $TERMUX_PREFIX/bin ./gotop
}
