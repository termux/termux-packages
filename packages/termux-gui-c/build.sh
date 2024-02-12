TERMUX_PKG_HOMEPAGE="https://github.com/tareksander/termux-gui-c-bindings"
TERMUX_PKG_DESCRIPTION="A C library for the Termux:GUI plugin"
TERMUX_PKG_LICENSE="MPL-2.0"
TERMUX_PKG_MAINTAINER="@tareksander"
TERMUX_PKG_VERSION="0.1.2"
TERMUX_PKG_BUILD_DEPENDS="protobuf-static"
TERMUX_PKG_SRCURL="https://github.com/tareksander/termux-gui-c-bindings/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=5588ae548473e98cfe39854207edd12a2c55909275f2461e7b52954aec7081cc
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"

termux_step_pre_configure() {
	termux_setup_protobuf
}
