TERMUX_PKG_HOMEPAGE=https://github.com/go-shiori/shiori
TERMUX_PKG_DESCRIPTION="Simple bookmark manager built with Go"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Krishna Kanhaiya @kcubeterm"
TERMUX_PKG_VERSION=1.5.2
TERMUX_PKG_SRCURL=https://github.com/go-shiori/shiori/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=c3eefab2f9a053ef43f4a4e3e7b2d8ab6c67bf7e8a86bca9afdf0f0edf73fa26
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make() {
	termux_setup_golang

	cd "$TERMUX_PKG_SRCDIR"
	
	export GOPATH=$TERMUX_PKG_BUILDDIR
	mkdir -p "$GOPATH"/src/github.com/go-shiori/
	mkdir -p "$TERMUX_PREFIX"/share/doc/shiori
	cp -a "$TERMUX_PKG_SRCDIR" "$GOPATH"/src/github.com/go-shiori/shiori
	cd "$GOPATH"/src/github.com/go-shiori/shiori/
	go get -d -v
	go build
}

termux_step_make_install() {
	install -Dm700 -t "$TERMUX_PREFIX"/bin "$GOPATH"/src/github.com/go-shiori/shiori/shiori
	cp -a "$TERMUX_PKG_SRCDIR"/docs/ "$TERMUX_PREFIX"/share/doc/shiori
}
