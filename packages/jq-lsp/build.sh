TERMUX_PKG_HOMEPAGE=https://github.com/wader/jq-lsp
TERMUX_PKG_DESCRIPTION="jq language server"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.1.17"
TERMUX_PKG_SRCURL=https://github.com/wader/jq-lsp/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=899cd2dcd4838d21bab1d84f687cb4a907e0fce7702990dac342b9b6fd88b5a2
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE=newest-tag
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	termux_setup_golang

	export GOPATH=$TERMUX_PKG_BUILDDIR

	cd $TERMUX_PKG_SRCDIR

	go build -o jq-lsp
}

termux_step_make_install() {
	cd $TERMUX_PKG_SRCDIR

	install -Dm700 -t $TERMUX_PREFIX/bin ./jq-lsp
}
