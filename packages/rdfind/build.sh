TERMUX_PKG_HOMEPAGE=https://github.com/pauldreik/rdfind
TERMUX_PKG_DESCRIPTION="A tool for finding duplicate files"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.7.0"
TERMUX_PKG_SRCURL=https://github.com/pauldreik/rdfind/archive/refs/tags/releases/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=bd17dbd9c6c9fc0c0b016b3e77ecf5cd718eee428172c767f429ba30405816d8
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+\.\d+\.\d+"
TERMUX_PKG_DEPENDS="libc++, libnettle"

termux_step_pre_configure() {
	autoreconf -fi
}
