TERMUX_PKG_HOMEPAGE=https://github.com/gravitational/teleport
TERMUX_PKG_DESCRIPTION="Secure Access for Developers that doesn't get in the way"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=11.0.3
TERMUX_PKG_REVISION=1
TERMUX_PKG_SKIP_SRC_EXTRACT=true

termux_step_make_install() {
	termux_setup_golang
	export GOPATH=$TERMUX_PKG_BUILDDIR
	export BUILDDIR=$TERMUX_PREFIX/bin

	mkdir -p $GOPATH/src/github.com/gravitational
	cd $GOPATH/src/github.com/gravitational
	git clone https://github.com/gravitational/teleport.git
	cd teleport

	git checkout "v$TERMUX_PKG_VERSION"

	make $BUILDDIR/tsh
}
