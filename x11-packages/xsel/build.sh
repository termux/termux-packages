TERMUX_PKG_HOMEPAGE=http://www.kfish.org/software/xsel/
TERMUX_PKG_DESCRIPTION="Command-line program for getting and setting the contents of the X selection"
# License: HPND
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="COPYING"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.2.1
TERMUX_PKG_SRCURL=https://github.com/kfish/xsel/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=18487761f5ca626a036d65ef2db8ad9923bf61685e06e7533676c56d7d60eb14
TERMUX_PKG_DEPENDS="libx11"

termux_step_pre_configure() {
	autoreconf -fi
}
