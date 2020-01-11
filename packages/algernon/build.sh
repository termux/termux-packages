TERMUX_PKG_HOMEPAGE=https://algernon.roboticoverlords.org/
TERMUX_PKG_DESCRIPTION="Small self-contained web server with Lua, Markdown, QUIC, Redis and PostgreSQL support"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
TERMUX_PKG_VERSION=1.12.6
TERMUX_PKG_SRCURL=https://github.com/xyproto/algernon/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=688f7fbd9f0cd62426a5d88d1d4ac0e300537f4bae2b5b6efcfea89f480c2cd2

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
