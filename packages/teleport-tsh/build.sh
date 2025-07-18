TERMUX_PKG_HOMEPAGE=https://github.com/gravitational/teleport
TERMUX_PKG_DESCRIPTION="Secure Access for Developers that doesn't get in the way"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="18.0.2"
TERMUX_PKG_SRCURL=https://github.com/gravitational/teleport/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=de20b1141769cc5f90ce9abb7e6de2ef11dcd6efb377c31373e5ddd4740aa835
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_HOSTBUILD=true

termux_step_host_build() {
	termux_setup_golang
	pushd "$TERMUX_PKG_SRCDIR"

	# from Makefile
	export KUBECTL_VERSION=$(go run ./build.assets/kubectl-version/main.go)
	popd
}

termux_step_make() {
	termux_setup_golang
	export GOPATH=$TERMUX_PKG_CACHEDIR/go
	export BUILDDIR=$TERMUX_PKG_SRCDIR/cmd

	make $BUILDDIR/tsh
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin $BUILDDIR/tsh
}
