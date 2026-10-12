TERMUX_PKG_HOMEPAGE=https://github.com/libxls/libxls
TERMUX_PKG_DESCRIPTION="A C library for reading Excel files in the nasty old binary OLE format"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.6.4"
TERMUX_PKG_SRCURL=https://github.com/libxls/libxls/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=4e696731266e9475e93941746548a4180385b54cc649a221ea6a2729e7cb1ab6
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--program-prefix=lib"

termux_step_pre_configure() {
	autoreconf -fi
}
