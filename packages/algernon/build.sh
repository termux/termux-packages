TERMUX_PKG_HOMEPAGE=https://algernon.roboticoverlords.org/
TERMUX_PKG_DESCRIPTION="Small self-contained web server with Lua, Markdown, QUIC, Redis and PostgreSQL support"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.12.14
TERMUX_PKG_SRCURL=https://github.com/xyproto/algernon/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=cab5b01923142e0326ea2a01797814bb2e8ea9f7c6c41a3ea0ae7df3b667e86e
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make() {
	termux_setup_golang

	export GOPATH=$TERMUX_PKG_BUILDDIR
	mkdir -p "$GOPATH"/src/github.com/xyproto
	ln -sf "$TERMUX_PKG_SRCDIR" "$GOPATH"/src/github.com/xyproto/algernon

	cd "$GOPATH"/src/github.com/xyproto/algernon

	go build
}

termux_step_make_install() {
	install -Dm700 \
		"$GOPATH"/src/github.com/xyproto/algernon/algernon \
		"$TERMUX_PREFIX"/bin/

	# Offline samples may be useful to get started with Algernon.
	rm -rf "$TERMUX_PREFIX"/share/doc/algernon
	mkdir -p "$TERMUX_PREFIX"/share/doc/algernon
	cp -a "$GOPATH"/src/github.com/xyproto/algernon/samples \
		"$TERMUX_PREFIX"/share/doc/algernon/
}
