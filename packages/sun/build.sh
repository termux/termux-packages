TERMUX_PKG_HOMEPAGE=https://stand-up-notes.org
TERMUX_PKG_DESCRIPTION="A very simple note taking cli app"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.0.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/basbossink/sun/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=f0c90b8796caa66662dd82790449ca844708e20b39f7e81ef7f1cbce211d1412
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make() {
	termux_setup_golang

	export GOPATH=$TERMUX_PKG_BUILDDIR
	mkdir -p "${TERMUX_PKG_BUILDDIR}"/src/github.com/basbossink/
	ln -sf "$TERMUX_PKG_SRCDIR" "$GOPATH"/src/github.com/basbossink/sun

	cd "$GOPATH"/src/github.com/basbossink/sun
	go build -ldflags "-s -w -X main.Version=${TERMUX_PKG_VERSION}" .
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin \
		${TERMUX_PKG_BUILDDIR}/src/github.com/basbossink/sun/sun
}
