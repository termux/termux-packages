TERMUX_PKG_HOMEPAGE=https://github.com/maaslalani/slides
TERMUX_PKG_DESCRIPTION="Slides in your terminal"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Yaksh Bariya <yakshbari4@gmail.com>"
TERMUX_PKG_VERSION=0.4.0
TERMUX_PKG_SRCURL=https://github.com/maaslalani/slides/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=320285f179c4c2de7810f945f6c27c1d57d97f3b4ee322867248f7f1a7c06adf

termux_step_make() {
	termux_setup_golang

	export GOPATH=$TERMUX_PKG_BUILDDIR
	cd "$TERMUX_PKG_SRCDIR"
	make build
}

termux_step_make_install() {
	install -Dm700 \
		"$TERMUX_PKG_SRCDIR"/slides \
		"$TERMUX_PREFIX"/bin/
}
