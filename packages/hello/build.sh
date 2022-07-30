TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/hello/
TERMUX_PKG_DESCRIPTION="Prints a friendly greeting"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.12.1
TERMUX_PKG_REVISION=0
TERMUX_PKG_SRCURL=https://ftp.gnu.org/gnu/hello/hello-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=8d99142afd92576f30b0cd7cb42a8dc6809998bc5d607d88761f512e26c7db20
TERMUX_PKG_DEPENDS="libiconv"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	LDFLAGS+=" -liconv"
}
