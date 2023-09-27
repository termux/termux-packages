TERMUX_PKG_HOMEPAGE=https://github.com/dmtx/dmtx-utils
TERMUX_PKG_DESCRIPTION="A command line interface for libdmtx"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.7.6
TERMUX_PKG_SRCURL=https://github.com/dmtx/dmtx-utils/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=0d396ec14f32a8cf9e08369a4122a16aa2e5fa1675e02218f16f1ab777ea2a28
TERMUX_PKG_DEPENDS="imagemagick, libdmtx"

termux_step_pre_configure() {
	autoreconf -fi
}
