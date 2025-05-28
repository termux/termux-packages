TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/hello/
TERMUX_PKG_DESCRIPTION="Prints a friendly greeting"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.12.2"
TERMUX_PKG_SRCURL=https://ftp.gnu.org/gnu/hello/hello-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=5a9a996dc292cc24dcf411cee87e92f6aae5b8d13bd9c6819b4c7a9dce0818ab
TERMUX_PKG_DEPENDS="libiconv"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	LDFLAGS+=" -liconv"
}
