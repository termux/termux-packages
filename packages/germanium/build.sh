TERMUX_PKG_HOMEPAGE=https://github.com/matsuyoshi30/germanium
TERMUX_PKG_DESCRIPTION="Generate image from source code"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Raven Ravener <ravener.anime@gmail.com>"
TERMUX_PKG_VERSION=1.2.2
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/matsuyoshi30/germanium/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=859fed54957f46e25b4577b561a810186cc21c1f0dfd99d5226e99764df195d9
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_get_source() {
	termux_setup_golang
	export GOPATH=$TERMUX_PKG_SRCDIR/go
	go get -d ./cmd/germanium
	chmod +w $GOPATH -R
}

termux_step_make() {
	export GOPATH=$TERMUX_PKG_SRCDIR/go
	go build -o germanium -v ./cmd/germanium
}
 
termux_step_make_install() {
	install -Dm700 -t "$TERMUX_PREFIX"/bin germanium
}
