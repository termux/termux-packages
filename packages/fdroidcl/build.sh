TERMUX_PKG_HOMEPAGE=https://github.com/mvdan/fdroidcl
TERMUX_PKG_DESCRIPTION="F-Droid client"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.7.0"
TERMUX_PKG_SRCURL=https://github.com/mvdan/fdroidcl/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=4dbbb2106c23564a19cdde912d3f06cd258f02eccd6382a0532ef64e7e61f2fd
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
