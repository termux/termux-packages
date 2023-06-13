TERMUX_PKG_HOMEPAGE="https://github.com/pkolaczk/fclones"
TERMUX_PKG_DESCRIPTION="Efficient Duplicate File Finder"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.32.1"
TERMUX_PKG_SRCURL="https://github.com/pkolaczk/fclones/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=313d4dad30ed1db4d74abd78f30a7a9917c361918d2bc6d84c9d97a2a8c7c5cb
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_get_source() {
	TERMUX_PKG_SRCDIR+=/fclones
}
