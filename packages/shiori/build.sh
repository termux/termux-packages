TERMUX_PKG_HOMEPAGE=https://github.com/go-shiori/shiori
TERMUX_PKG_DESCRIPTION="Simple bookmark manager built with Go"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Krishna Kanhaiya @kcubeterm"
TERMUX_PKG_VERSION=1.5.1
TERMUX_PKG_SRCURL=https://github.com/go-shiori/shiori/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=d7d9c00b8b2866b51f58dcea9b045ae560deb9b48093a2cb56dc17881ea055b2
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
