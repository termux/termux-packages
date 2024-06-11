TERMUX_PKG_HOMEPAGE=https://github.com/gravitational/teleport
TERMUX_PKG_DESCRIPTION="Secure Access for Developers that doesn't get in the way"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="15.4.2"
TERMUX_PKG_SRCURL=https://github.com/gravitational/teleport/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=7482acd9b111ada7986529522f29cdffd9bc9cc716cb68ffd2b2cad995716dc0
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	termux_setup_golang
	export GOPATH=$TERMUX_PKG_CACHEDIR/go
	export BUILDDIR=$TERMUX_PKG_SRCDIR/cmd

	make $BUILDDIR/tsh
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin $BUILDDIR/tsh
}
