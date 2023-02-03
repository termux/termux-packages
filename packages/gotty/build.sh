TERMUX_PKG_HOMEPAGE=https://github.com/sorenisanerd/gotty
TERMUX_PKG_DESCRIPTION="Share your terminal as a web application"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.5.0"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/sorenisanerd/gotty/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=98a5fb9eddefc4bc4d402ad159d274a3876ee2b23cb8940ebeea328b705454a7
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make() {
	termux_setup_golang

	export GOPATH=$TERMUX_PKG_BUILDDIR
	mkdir -p "$GOPATH"/src/github.com/yudai
	ln -sf "$TERMUX_PKG_SRCDIR" "$GOPATH"/src/github.com/yudai/gotty

	cd "$GOPATH"/src/github.com/yudai/gotty
	go mod init || go mod download
	#go mod tidy
	go build
}

termux_step_make_install() {
	install -Dm700 \
		"$GOPATH"/src/github.com/yudai/gotty/gotty \
		"$TERMUX_PREFIX"/bin/
}
