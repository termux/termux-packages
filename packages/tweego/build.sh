TERMUX_PKG_HOMEPAGE=https://bitbucket.org/tmedwards/tweego
TERMUX_PKG_DESCRIPTION="A free command line compiler for Twine/Twee story formats"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com> @xeffyr"
TERMUX_PKG_VERSION=1.3.0
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://bitbucket.org/tmedwards/tweego/get/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=1c62e3d91d7f3b208695896a51b19771e6f94af7b42d99aa00022b405473d895

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
