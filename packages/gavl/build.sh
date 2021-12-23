TERMUX_PKG_HOMEPAGE=http://gmerlin.sourceforge.net/
TERMUX_PKG_DESCRIPTION="Gmerlin Audio Video Library"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_LICENSE=GPL-3.0
TERMUX_PKG_LICENSE_FILE=COPYING
TERMUX_PKG_VERSION=1.4.0
TERMUX_PKG_SRCURL=https://sourceforge.net/projects/gmerlin/files/gavl/${TERMUX_PKG_VERSION}/gavl-${TERMUX_PKG_VERSION}.tar.gz/download
TERMUX_PKG_DEPENDS="doxygen, libpng"
TERMUX_PKG_SHA256=51aaac41391a915bd9bad07710957424b046410a276e7deaff24a870929d33ce
termux_step_pre_configure() {
	${TERMUX_PKG_SRCDIR}/autogen.sh
	export LIBS="-lm" 
}
