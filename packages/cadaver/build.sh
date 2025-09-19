TERMUX_PKG_HOMEPAGE=https://notroj.github.io/cadaver/
TERMUX_PKG_DESCRIPTION="A command-line WebDAV client for Unix"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.28"
TERMUX_PKG_SRCURL=https://notroj.github.io/cadaver/cadaver-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=33e3a54bd54b1eb325b48316a7cacc24047c533ef88e6ef98b88dfbb60e12734
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_DEPENDS="libiconv, libneon, readline"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-nls
"

termux_step_pre_configure() {
	./autogen.sh
}
