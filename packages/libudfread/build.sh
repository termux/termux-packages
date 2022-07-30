TERMUX_PKG_HOMEPAGE=https://code.videolan.org/videolan/libudfread/
TERMUX_PKG_DESCRIPTION="A library for reading UDF"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.1.2
TERMUX_PKG_REVISION=0
TERMUX_PKG_SRCURL=https://code.videolan.org/videolan/libudfread/-/archive/${TERMUX_PKG_VERSION}/libudfread-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=2bf16726ac98d093156195bb049a663e07d3323e079c26912546f4e05c77bac5

termux_step_pre_configure() {
	autoreconf -fi
}
