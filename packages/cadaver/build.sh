TERMUX_PKG_HOMEPAGE=https://notroj.github.io/cadaver/
TERMUX_PKG_DESCRIPTION="A command-line WebDAV client for Unix"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.26"
TERMUX_PKG_SRCURL=https://notroj.github.io/cadaver/cadaver-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=9236e43cdf3505d9ef06185fda43252840105c0c02d9370b6e1077d866357b55
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_DEPENDS="libiconv, libneon, readline"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-nls
"

termux_step_pre_configure() {
	./autogen.sh
}
