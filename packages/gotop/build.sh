TERMUX_PKG_HOMEPAGE=https://github.com/xxxserxxx/gotop
TERMUX_PKG_DESCRIPTION="A terminal based graphical activity monitor inspired by gtop and vtop"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@medzikuser"
TERMUX_PKG_VERSION="4.1.3"
TERMUX_PKG_SRCURL=https://github.com/xxxserxxx/gotop/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=c0a02276e718b988d1220dc452063759c8634d42e1c01a04c021486c1e61612d
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
