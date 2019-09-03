TERMUX_PKG_HOMEPAGE=https://bitbucket.org/tmedwards/tweego
TERMUX_PKG_DESCRIPTION="A free command line compiler for Twine/Twee story formats"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
TERMUX_PKG_VERSION=2.0.0
TERMUX_PKG_SRCURL=https://bitbucket.org/tmedwards/tweego/get/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=59aef611a91a8a79cc7d216d401b3f3536077da8b3d3a8013ae42633e9c7e736

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
