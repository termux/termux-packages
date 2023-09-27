TERMUX_PKG_HOMEPAGE="https://github.com/tareksander/termux-gui-c-bindings"
TERMUX_PKG_DESCRIPTION="A C library for the Termux:GUI plugin"
TERMUX_PKG_LICENSE="MPL-2.0"
TERMUX_PKG_MAINTAINER="@tareksander"
TERMUX_PKG_VERSION="0.1.1"
TERMUX_PKG_BUILD_DEPENDS="protobuf-static"
TERMUX_PKG_SRCURL="https://github.com/tareksander/termux-gui-c-bindings/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=02e5e65bb3bfb0cc27748420af4984faa63cefa02c096b5706c1cf39425890d1
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"

termux_step_pre_configure() {
	termux_setup_protobuf
}
