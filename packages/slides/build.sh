TERMUX_PKG_HOMEPAGE=https://github.com/maaslalani/slides
TERMUX_PKG_DESCRIPTION="Slides in your terminal"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Yaksh Bariya <yakshbari4@gmail.com>"
TERMUX_PKG_VERSION=0.2.0
TERMUX_PKG_SRCURL=https://github.com/maaslalani/slides/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=c4f441e667c44ed97191be1974ee70d43a0b421104a9f432b9dda300399e0166

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
