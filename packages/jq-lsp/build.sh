TERMUX_PKG_HOMEPAGE=https://github.com/wader/jq-lsp
TERMUX_PKG_DESCRIPTION="jq language server"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.1.7"
TERMUX_PKG_SRCURL=$TERMUX_PKG_HOMEPAGE/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=c49691d1b0635f05deb1ffa6edd1bc512585dbae54dc3f0b99ffd0e0f109c07a
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
