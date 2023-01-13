TERMUX_PKG_HOMEPAGE=https://github.com/mvdan/fdroidcl
TERMUX_PKG_DESCRIPTION="F-Droid client"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.6.0"
TERMUX_PKG_SRCURL=https://github.com/mvdan/fdroidcl/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=d9031c8b1a7e03ab382ffaf49da2c199e978d65f64ebe52168509b6ad8b7bb07
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
