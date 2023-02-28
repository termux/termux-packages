TERMUX_PKG_HOMEPAGE=https://github.com/xyproto/o
TERMUX_PKG_DESCRIPTION="Small, fast and limited text editor"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="Alexander F. Rødseth <xyproto@archlinux.org>"
TERMUX_PKG_VERSION=2.60.2
TERMUX_PKG_SRCURL=https://github.com/xyproto/o/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=6f609e867a1678d13300df7a1ab0f4a4c119c4fab3ff4c1588d5521dbadec5d5
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BREAKS="o"
TERMUX_PKG_REPLACES="o"

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
