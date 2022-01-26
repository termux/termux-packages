TERMUX_PKG_HOMEPAGE=https://github.com/libxls/libxls
TERMUX_PKG_DESCRIPTION="A C library for reading Excel files in the nasty old binary OLE format"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.6.2
TERMUX_PKG_SRCURL=https://github.com/libxls/libxls/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=2f836fcef6372c6bc882c3e80bfd3043812e2fc4d4534022a25b24fe801b1770

termux_step_pre_configure() {
	autoreconf -fi
}
