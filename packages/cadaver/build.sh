TERMUX_PKG_HOMEPAGE=https://notroj.github.io/cadaver/
TERMUX_PKG_DESCRIPTION="A command-line WebDAV client for Unix"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.27"
TERMUX_PKG_SRCURL=https://notroj.github.io/cadaver/cadaver-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=12afc62b23e1291270e95e821dcab0d5746ba4461cbfc84d08c2aebabb2ab54f
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_DEPENDS="libiconv, libneon, readline"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-nls
"

termux_step_pre_configure() {
	./autogen.sh
}
