TERMUX_PKG_HOMEPAGE=https://github.com/matsuyoshi30/germanium
TERMUX_PKG_DESCRIPTION="Generate image from source code"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Raven Ravener <ravener.anime@gmail.com>"
TERMUX_PKG_VERSION=1.2.0
TERMUX_PKG_SRCURL=https://github.com/matsuyoshi30/germanium/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=9a2b190ea7e8211ed03fa6860aea73ef06228266d7b6e4d32df2031fdf1c9606
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	termux_setup_golang
	make build
}
 
termux_step_make_install() {
	install -Dm700 -t "$TERMUX_PREFIX"/bin germanium
}
