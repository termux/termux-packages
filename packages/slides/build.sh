TERMUX_PKG_HOMEPAGE=https://github.com/maaslalani/slides
TERMUX_PKG_DESCRIPTION="Slides in your terminal"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Yaksh Bariya <yakshbari4@gmail.com>"
TERMUX_PKG_VERSION=0.6.2
TERMUX_PKG_SRCURL=https://github.com/maaslalani/slides/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=67de7cd34317bfba774102c690cd7de9f6d5b8f0271d34c1a5eff5fbb22f36b8
TERMUX_PKG_AUTO_UPDATE=true

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
