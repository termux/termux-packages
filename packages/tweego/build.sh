TERMUX_PKG_HOMEPAGE=https://bitbucket.org/tmedwards/tweego
TERMUX_PKG_DESCRIPTION="A free command line compiler for Twine/Twee story formats"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.1.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/tmedwards/tweego/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=73c2f00e6b19bd7339b2c431a32f51f4514f7b32130dd5738ece6efbf0664343

termux_step_make() {
	termux_setup_golang

	export GOPATH=$TERMUX_PKG_BUILDDIR
	mkdir -p "$GOPATH"/src/bitbucket.org/tmedwards
	ln -sf "$TERMUX_PKG_SRCDIR" "$GOPATH"/src/bitbucket.org/tmedwards/tweego

	cd "$GOPATH"/src/bitbucket.org/tmedwards/tweego
	go get -d -v bitbucket.org/tmedwards/tweego
	go build
}

termux_step_make_install() {
	install -Dm700 \
		"$GOPATH"/src/bitbucket.org/tmedwards/tweego/tweego \
		"$TERMUX_PREFIX"/bin/
}
