TERMUX_PKG_HOMEPAGE=https://wiki.termux.com/wiki/Termux:API
TERMUX_PKG_DESCRIPTION="Termux API commands (install also the Termux:API app)"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.59.1
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/termux/termux-api-package/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=92c2da07991a0191735539428aabb793e0ddb8e33baac305bcf38d77aa1eda80
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_DEPENDS="bash, libusb, libprotobuf-c, util-linux, termux-am (>= 0.8.0)"

termux_step_pre_configure() {
	termux_setup_protobuf
}
