TERMUX_PKG_HOMEPAGE=https://github.com/cosmtrek/air
TERMUX_PKG_DESCRIPTION="Live reload for Go apps"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@medzikuser"
TERMUX_PKG_VERSION=1.27.3
TERMUX_PKG_SRCURL=https://github.com/cosmtrek/air/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=843a75d4852363a11133a473c48496249b6222cd612ddfdb51da4377142c33e4
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make_install() {
	termux_setup_golang

	export GOPATH=$TERMUX_PKG_BUILDDIR

	cd $TERMUX_PKG_SRCDIR

	go build \
		-o air \
		-ldflags "-X main.version=$TERMUX_PKG_VERSION -X main.goVersion=$(go version | grep -Po '.*go\K.* ')"

	install -Dm700 -t $TERMUX_PREFIX/bin ./air
}
