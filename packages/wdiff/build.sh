TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/wdiff/
TERMUX_PKG_DESCRIPTION="Display word differences between text files"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.2.3
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/wdiff/wdiff-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=29a4457eb0ed35c902e6732d71f25e1d6c7fe7fa0eda0fb6c371ed6779b49fd6
TERMUX_PKG_DEPENDS="ncurses"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-threads
"
