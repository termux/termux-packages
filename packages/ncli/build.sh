TERMUX_PKG_HOMEPAGE="https://github.com/dev-aemni/ncli"
TERMUX_PKG_DESCRIPTION="A versatile command-line text editor and note-taking utility"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@dev-aemni"
TERMUX_PKG_VERSION="1.1.1"
TERMUX_PKG_SRCURL="https://github.com/dev-aemni/ncli/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256="P0019dfc4b32d63c1392aa264aed2253c1e0c2fb09216f8e2cc269bbfb8bb49b5"
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make_install() {
	make install PREFIX="$TERMUX_PREFIX"
}
