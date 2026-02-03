TERMUX_PKG_HOMEPAGE=https://github.com/gravitational/teleport
TERMUX_PKG_DESCRIPTION="Secure Access for Developers that doesn't get in the way"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="18.6.6"
TERMUX_PKG_SRCURL=https://github.com/gravitational/teleport/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=c8e6f0302e475f78bef7af70f5f3f101740d2d6417ad3c2a2c55fcd47a38f286
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
