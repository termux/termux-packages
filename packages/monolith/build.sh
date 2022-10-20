TERMUX_PKG_HOMEPAGE="https://github.com/Y2Z/monolith"
TERMUX_PKG_DESCRIPTION="CLI tool for saving complete web pages as a single HTML file"
TERMUX_PKG_LICENSE="CC0-1.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.6.2"
TERMUX_PKG_SRCURL="https://github.com/Y2Z/monolith/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=15287b101b021f17cba13ca0b64c58a8be54bb061ba4b7c291eb57faf799977b
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_DEPENDS="openssl"

termux_step_pre_configure() {
    rm -f Makefile
}
