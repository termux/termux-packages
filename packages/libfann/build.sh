TERMUX_PKG_HOMEPAGE="http://leenissen.dk/fann/wp"
TERMUX_PKG_DESCRIPTION="Fast artificial neural network library"
TERMUX_PKG_GROUPS="science"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.2.0"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL="https://github.com/libfann/fann/archive/refs/tags/$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=f31c92c1589996f97d855939b37293478ac03d24b4e1c08ff21e0bd093449c3c
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag" # As of 2022-08-29T00:33:40 no github releases are available.

termux_step_pre_configure() {
	LDFLAGS+=" -lm"
}
