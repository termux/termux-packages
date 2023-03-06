TERMUX_PKG_HOMEPAGE=http://modplug-xmms.sourceforge.net/
TERMUX_PKG_DESCRIPTION="The ModPlug mod file playing library"
TERMUX_PKG_LICENSE="Public Domain"
TERMUX_PKG_LICENSE_FILE="COPYING"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.8.9.1.r461
TERMUX_PKG_SRCURL=https://github.com/ShiftMediaProject/modplug/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=d489a13cc863180b0f8209ad7b69d4413df454858d6f4ce94a03669213dc56cd
TERMUX_PKG_DEPENDS="libc++"

termux_step_pre_configure() {
	autoreconf -fi

	LDFLAGS+=" $($CC -print-libgcc-file-name)"
}
