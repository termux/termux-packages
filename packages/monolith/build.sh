TERMUX_PKG_HOMEPAGE="https://github.com/Y2Z/monolith"
TERMUX_PKG_DESCRIPTION="CLI tool for saving complete web pages as a single HTML file"
TERMUX_PKG_LICENSE="CC0-1.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.8.1"
TERMUX_PKG_SRCURL="https://github.com/Y2Z/monolith/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=16bc9010f6a425ffa6cc71e01ab72bb3c9029f736c30918bff70157115b3ae9c
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_DEPENDS="openssl"

termux_step_pre_configure() {
	rm -f Makefile
}
