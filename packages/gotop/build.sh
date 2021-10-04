TERMUX_PKG_HOMEPAGE=https://github.com/xxxserxxx/gotop
TERMUX_PKG_DESCRIPTION="A terminal based graphical activity monitor inspired by gtop and vtop"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@medzikuser"
TERMUX_PKG_VERSION=4.1.2
TERMUX_PKG_SRCURL=https://github.com/xxxserxxx/gotop/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=81518fecfdab4f4c25a4713e24d9c033ba8311bbd3e2c0435ba76349028356da

termux_step_make_install() {
	termux_setup_golang

	export GOPATH=$TERMUX_PKG_BUILDDIR

	cd $TERMUX_PKG_SRCDIR

	go build -o gotop \
	    -ldflags "-X main.Version=v${TERMUX_PKG_VERSION} -X main.BuildDate=$(date +%Y%m%dT%H%M%S)" \
	    ./cmd/gotop

	install -Dm700 -t $TERMUX_PREFIX/bin/gotop ./gotop
}
