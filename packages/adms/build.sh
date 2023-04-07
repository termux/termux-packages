TERMUX_PKG_HOMEPAGE="https://github.com/qucs/adms"
TERMUX_PKG_DESCRIPTION="A code generator for the Verilog-AMS language"
TERMUX_PKG_GROUPS="science"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.3.7"
TERMUX_PKG_SRCURL="https://github.com/Qucs/ADMS/archive/refs/tags/release-$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=0d24f645d7ce0daa447af1b0cff1123047f3b73cc41cf403650f469721f95173
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+\.\d+\.\d+"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-maintainer-mode
--enable-shared
--disable-static
"

termux_step_pre_configure() {
	./bootstrap.sh
}
