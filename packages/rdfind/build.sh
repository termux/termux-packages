TERMUX_PKG_HOMEPAGE=https://github.com/pauldreik/rdfind
TERMUX_PKG_DESCRIPTION="A tool for finding duplicate files"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.6.0
TERMUX_PKG_SRCURL=https://github.com/pauldreik/rdfind/archive/refs/tags/releases/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=9198d41c7a14bdf29c347570bab5001a56a4d23c1bc2e962115dccbc2d0d2265
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+\.\d+\.\d+"
TERMUX_PKG_DEPENDS="libc++, libnettle"

termux_step_pre_configure() {
	autoreconf -fi
}
