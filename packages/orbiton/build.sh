TERMUX_PKG_HOMEPAGE=https://roboticoverlords.org/orbiton/
TERMUX_PKG_DESCRIPTION="Small, fast and limited text editor"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="Alexander F. Rødseth <xyproto@archlinux.org>"
TERMUX_PKG_VERSION="2.72.0"
TERMUX_PKG_SRCURL=https://github.com/xyproto/orbiton/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=eb0e61a0c032f5d41281dd42508e64fc653491103d9e32999c0cc621a4e44dff
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
