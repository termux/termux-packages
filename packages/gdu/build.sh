TERMUX_PKG_HOMEPAGE=https://github.com/dundee/gdu
TERMUX_PKG_DESCRIPTION="Fast disk usage analyzer with console interface written in Go"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="5.30.1"
TERMUX_PKG_SRCURL=https://github.com/dundee/gdu/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=ad363967b6a34e02812e4cba36bb340f377cf64a435e23f6e8e9e6b3f775220e
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	termux_setup_golang
	sed -i 's|CGO_ENABLED=0|CGO_ENABLED=1|g' Makefile

	make build VERSION=$TERMUX_PKG_VERSION
	make gdu.1
}

termux_step_make_install() {
	install -D dist/gdu -t $TERMUX_PREFIX/bin
	install -Dm644 gdu.1 -t $TERMUX_PREFIX/share/man/man1
}
