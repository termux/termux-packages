TERMUX_PKG_HOMEPAGE=https://github.com/sorenisanerd/gotty
TERMUX_PKG_DESCRIPTION="Share your terminal as a web application"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.11.0"
TERMUX_PKG_SRCURL=https://github.com/sorenisanerd/gotty/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=46159ace155d77d0b7f08de120a012b5c25987440f42c95dc1cde95cb32f6ab2
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
