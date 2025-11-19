TERMUX_PKG_HOMEPAGE=https://github.com/mvdan/fdroidcl
TERMUX_PKG_DESCRIPTION="F-Droid client"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.8.1"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/mvdan/fdroidcl/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=934881b18ce13a7deb246321678eabd3f81284cae61ff4d18bde6c7c4217584a
TERMUX_PKG_DEPENDS="android-tools"
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make() {
	termux_setup_golang
	export GOPATH=$TERMUX_PKG_BUILDDIR

	mkdir -p "$GOPATH"/src/mvdan.cc
	cp -a "$TERMUX_PKG_SRCDIR" "$GOPATH"/src/mvdan.cc/fdroidcl
	cd "$GOPATH"/src/mvdan.cc/fdroidcl

	go build .
}

termux_step_make_install() {
	install -Dm700 "$TERMUX_PKG_BUILDDIR"/src/mvdan.cc/fdroidcl/fdroidcl \
		"$TERMUX_PREFIX"/bin/fdroidcl
}
