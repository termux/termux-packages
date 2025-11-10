TERMUX_PKG_HOMEPAGE="https://github.com/xsser01/phantomcollect"
TERMUX_PKG_DESCRIPTION="Advanced web data collection framework"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@xsser01"
TERMUX_PKG_VERSION="1.0.0"
TERMUX_PKG_SRCURL=https://github.com/xsser01/phantomcollect/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256="cab9e6e4fc41277fc1732a955dc6083d44fc8a6127f2118ab300a219555b37c9"
TERMUX_PKG_DEPENDS="python"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make_install() {
	pip install . --prefix=$TERMUX_PREFIX
}
