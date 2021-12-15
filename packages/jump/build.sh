TERMUX_PKG_HOMEPAGE=https://github.com/gsamokovarov/jump
TERMUX_PKG_DESCRIPTION="Jump helps you navigate in shell faster by learning your habits"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.40.0
TERMUX_PKG_SRCURL=https://github.com/gsamokovarov/jump/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=f005f843fc65b7be1d4159da7d4c220eef0229ecec9935c6ac23e4963eef645e

termux_step_make() {
	termux_setup_golang
	export GOPATH=$TERMUX_PKG_BUILDDIR
	cd $TERMUX_PKG_SRCDIR
	go build .
}

termux_step_make_install() {
	install -Dm755 -t "${TERMUX_PREFIX}"/bin \
		"${TERMUX_PKG_SRCDIR}"/jump
}
