TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/hello/
TERMUX_PKG_DESCRIPTION="Prints a friendly greeting"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.12.3"
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/hello/hello-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=0d5f60154382fee10b114a1c34e785d8b1f492073ae2d3a6f7b147687b366aa0
TERMUX_PKG_DEPENDS="libiconv"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	LDFLAGS+=" -liconv"
}
