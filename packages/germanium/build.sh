TERMUX_PKG_HOMEPAGE=https://github.com/matsuyoshi30/germanium
TERMUX_PKG_DESCRIPTION="Generate image from source code"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Raven Ravener <ravener.anime@gmail.com>"
TERMUX_PKG_VERSION=0.3.0
TERMUX_PKG_SRCURL=https://github.com/matsuyoshi30/germanium/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=44fc26bb263f409363618ab091b7ca877f11870edbff436efc5fe2d4e950beda
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	termux_setup_golang
	go build
}
 
termux_step_make_install() {
	install -Dm700 -t "$TERMUX_PREFIX"/bin germanium
}
