TERMUX_PKG_HOMEPAGE=https://github.com/xxxserxxx/gotop
TERMUX_PKG_DESCRIPTION="A terminal based graphical activity monitor inspired by gtop and vtop"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@medzikuser"
_MAJOR_VERSION=4.1.2
# Use the ~ deb versioning construct in the future:
TERMUX_PKG_VERSION=1:${_MAJOR_VERSION}
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/xxxserxxx/gotop/archive/refs/tags/v${_MAJOR_VERSION}.tar.gz
TERMUX_PKG_SHA256=81518fecfdab4f4c25a4713e24d9c033ba8311bbd3e2c0435ba76349028356da
TERMUX_PKG_NO_STATICSPLIT=true

termux_step_make_install() {
	termux_setup_golang

	GOOS=android GOARCH=$TERMUX_ARCH go build -o gotop \
	    -ldflags "-X main.Version=v${_MAJOR_VERSION} -X main.BuildDate=$(date +%Y%m%dT%H%M%S)" \
	    ./cmd/gotop
}

termux_step_post_massage() {
	find . -path '*/testdata*' -delete
}
