TERMUX_PKG_HOMEPAGE=https://github.com/vmchale/tin-summer
TERMUX_PKG_DESCRIPTION="Find build artifacts that are taking up disk space"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.21.14
TERMUX_PKG_SRCURL=https://github.com/vmchale/tin-summer/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=8a4883b7a6354c6340e73a87d1009c0cc79bdfa135fe947317705dad9f0a6727
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	sed -i 's/linux/android/g' src/utils.rs
}
