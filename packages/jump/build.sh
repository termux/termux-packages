TERMUX_PKG_HOMEPAGE=https://github.com/gsamokovarov/jump
TERMUX_PKG_DESCRIPTION="Jump helps you navigate in shell faster by learning your habits"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.51.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/gsamokovarov/jump/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=ce297cada71e1dca33cd7759e55b28518d2bf317cdced1f3b3f79f40fa1958b5

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
