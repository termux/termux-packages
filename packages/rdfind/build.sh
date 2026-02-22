TERMUX_PKG_HOMEPAGE=https://github.com/pauldreik/rdfind
TERMUX_PKG_DESCRIPTION="A tool for finding duplicate files"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.8.0"
TERMUX_PKG_SRCURL=https://github.com/pauldreik/rdfind/archive/refs/tags/releases/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=6651603138cb91872d3e1628af5b89992f1937a86201645e8387fa42f98bc206
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+\.\d+\.\d+"
TERMUX_PKG_DEPENDS="libc++, libnettle"

termux_step_pre_configure() {
	autoreconf -fi
}
