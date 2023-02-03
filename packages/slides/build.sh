TERMUX_PKG_HOMEPAGE=https://github.com/maaslalani/slides
TERMUX_PKG_DESCRIPTION="Slides in your terminal"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Yaksh Bariya <yakshbari4@gmail.com>"
TERMUX_PKG_VERSION="0.9.0"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/maaslalani/slides/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=fcce0dbbe767e0b1f0800e4ea934ee9babbfb18ab2ec4b343e3cd6359cd48330
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
