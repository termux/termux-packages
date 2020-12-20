TERMUX_PKG_HOMEPAGE=https://github.com/vmchale/tin-summer
TERMUX_PKG_DESCRIPTION="Find build artifacts that are taking up disk space"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.21.8
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/vmchale/tin-summer/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=d9a6f4b41c759c291c91348914635243df0f13d38985d398bbb48a39ab4b338c
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	sed -i 's/linux/android/g' src/utils.rs
}
