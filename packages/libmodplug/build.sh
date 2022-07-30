TERMUX_PKG_HOMEPAGE=http://modplug-xmms.sourceforge.net/
TERMUX_PKG_DESCRIPTION="The ModPlug mod file playing library"
TERMUX_PKG_LICENSE="Public Domain"
TERMUX_PKG_LICENSE_FILE="COPYING"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.8.9.0
TERMUX_PKG_REVISION=0
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/modplug-xmms/libmodplug-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=457ca5a6c179656d66c01505c0d95fafaead4329b9dbaa0f997d00a3508ad9de
TERMUX_PKG_DEPENDS="libc++"

termux_step_pre_configure() {
	LDFLAGS+=" $($CC -print-libgcc-file-name)"
}
