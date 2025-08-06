TERMUX_PKG_HOMEPAGE=https://ollama.com/
TERMUX_PKG_DESCRIPTION="Get up and running with large language models"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.11.3"
TERMUX_PKG_SRCURL=git+https://github.com/ollama/ollama
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="latest-release-tag"
TERMUX_PKG_EXCLUDED_ARCHES="arm, i686"

termux_step_make_install() {
	cd $TERMUX_PKG_SRCDIR
	termux_setup_golang

	go build -trimpath -ldflags="-w -s -X=github.com/ollama/ollama/version.Version=$TERMUX_PKG_VERSION -X=github.com/ollama/ollama/server.mode=release"
	install -Dm700 ollama $TERMUX_PREFIX/bin/

	mkdir -p $TERMUX_PREFIX/lib/ollama
	cp -fv $TERMUX_PKG_BUILDDIR/lib/ollama/* $TERMUX_PREFIX/lib/ollama/
}
