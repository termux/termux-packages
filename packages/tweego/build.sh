TERMUX_PKG_HOMEPAGE=https://bitbucket.org/tmedwards/tweego
TERMUX_PKG_DESCRIPTION="A free command line compiler for Twine/Twee story formats"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.1.1
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/tmedwards/tweego/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=f58991ff0b5b344ebebb5677b7c21209823fa6d179397af4a831e5ef05f28b02
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make() {
	termux_setup_golang

	export GOPATH=$TERMUX_PKG_BUILDDIR
	mkdir -p "$GOPATH"/src/github.com/tmedwards
	ln -sf "$TERMUX_PKG_SRCDIR" "$GOPATH"/src/github.com/tmedwards/tweego

	cd "$GOPATH"/src/github.com/tmedwards/tweego
	go get -d -v github.com/tmedwards/tweego
	go build
}

termux_step_make_install() {
	install -Dm700 \
		"$GOPATH"/src/github.com/tmedwards/tweego/tweego \
		"$TERMUX_PREFIX"/bin/
}
