TERMUX_PKG_HOMEPAGE=https://github.com/gsamokovarov/jump
TERMUX_PKG_DESCRIPTION="Jump helps you navigate in shell faster by learning your habits"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.69.0
TERMUX_PKG_SRCURL=https://github.com/gsamokovarov/jump/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=17567f7acd305e2e8093f49e591aa03d74bc5c94204b0461550b0bd8055490af
TERMUX_PKG_AUTO_UPDATE=true

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
