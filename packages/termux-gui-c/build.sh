TERMUX_PKG_HOMEPAGE="https://github.com/tareksander/termux-gui-c-bindings"
TERMUX_PKG_DESCRIPTION="A C library for the Termux:GUI plugin"
TERMUX_PKG_LICENSE="MPL-2.0"
TERMUX_PKG_MAINTAINER="@tareksander"
TERMUX_PKG_VERSION="0.1.0"
TERMUX_PKG_BUILD_DEPENDS="protobuf-static"
TERMUX_PKG_SRCURL="https://github.com/tareksander/termux-gui-c-bindings/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256="168bfd4ef6491be6efec3a228b4d3d94b746ec7ebb0cf205bed233bf85048197"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"

termux_step_pre_configure() {
	termux_setup_protobuf
}
