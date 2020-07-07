TERMUX_PKG_HOMEPAGE=https://algernon.roboticoverlords.org/
TERMUX_PKG_DESCRIPTION="Small self-contained web server with Lua, Markdown, QUIC, Redis and PostgreSQL support"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_VERSION=1.12.7
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/xyproto/algernon/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=1e04be1274b875a90f3ca1b5685f0e2c2df79ae3b798a1c56395d0b5b5b686b3

termux_step_make() {
	termux_setup_golang

	export GOPATH=$TERMUX_PKG_BUILDDIR
	mkdir -p "$GOPATH"/src/github.com/xyproto
	ln -sf "$TERMUX_PKG_SRCDIR" "$GOPATH"/src/github.com/xyproto/algernon

	cd "$GOPATH"/src/github.com/xyproto/algernon

	# Needed to deal with following error on v1.12.5:
	#  verifying github.com/lucas-clemente/quic-go@v0.12.0: checksum mismatch
	rm -f go.sum

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
