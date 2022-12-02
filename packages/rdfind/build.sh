TERMUX_PKG_HOMEPAGE=https://github.com/pauldreik/rdfind
TERMUX_PKG_DESCRIPTION="A tool for finding duplicate files"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.5.0
TERMUX_PKG_SRCURL=https://github.com/pauldreik/rdfind/archive/refs/tags/releases/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=5abf0095aef194f0174614f9a339f0f0f0eb89a27e27ccd5c2aa76b411894f08
TERMUX_PKG_DEPENDS="libc++, libnettle"

termux_step_pre_configure() {
	autoreconf -fi
}
