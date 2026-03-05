TERMUX_PKG_HOMEPAGE=https://roboticoverlords.org/orbiton/
TERMUX_PKG_DESCRIPTION="Small, fast and limited text editor"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="Alexander F. Rødseth <xyproto@archlinux.org>"
TERMUX_PKG_VERSION="2.73.0"
TERMUX_PKG_SRCURL=https://github.com/xyproto/orbiton/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=238b58634578fb2f712c255d1493f9658ecf3a1667399825b26aff701cfd9869
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BREAKS="o, o-editor"
TERMUX_PKG_REPLACES="o, o-editor"

termux_step_make() {
	termux_setup_golang

	export GOPATH=$TERMUX_PKG_BUILDDIR
	mkdir -p "$GOPATH"/src/github.com/xyproto
	ln -sf "$TERMUX_PKG_SRCDIR" "$GOPATH"/src/github.com/xyproto/o

	cd "$GOPATH"/src/github.com/xyproto/o/v2
	go build
}

termux_step_make_install() {
	install -Dm700 -t "$TERMUX_PREFIX"/bin \
		"$GOPATH"/src/github.com/xyproto/o/v2/orbiton
	ln -sfT orbiton "$TERMUX_PREFIX"/bin/o
	install -Dm600 -t "$TERMUX_PREFIX"/share/man/man1 \
		"$TERMUX_PKG_SRCDIR"/o.1
}
