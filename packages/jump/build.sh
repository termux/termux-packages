TERMUX_PKG_HOMEPAGE=https://github.com/gsamokovarov/jump
TERMUX_PKG_DESCRIPTION="Jump helps you navigate in shell faster by learning your habits"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.50.0
TERMUX_PKG_SRCURL=https://github.com/gsamokovarov/jump/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=7832e968c81659e3750b8ecaaa49eb769fff4a96e790e28ef3d1e479f11affb4

termux_step_make() {
	termux_setup_golang
	export GOPATH=$TERMUX_PKG_BUILDDIR
	cd $TERMUX_PKG_SRCDIR
	go build .
}

termux_step_make_install() {
	install -Dm755 -t "${TERMUX_PKG_MASSAGEDIR}/${TERMUX_PREFIX}"/bin \
		${TERMUX_PKG_SRCDIR}/jump
}
