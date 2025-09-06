TERMUX_PKG_HOMEPAGE="https://github.com/tareksander/termux-gui-c-bindings"
TERMUX_PKG_DESCRIPTION="A C library for the Termux:GUI plugin"
TERMUX_PKG_LICENSE="MPL-2.0"
TERMUX_PKG_MAINTAINER="@tareksander"
TERMUX_PKG_VERSION="0.1.3"
TERMUX_PKG_REVISION=4
TERMUX_PKG_DEPENDS="abseil-cpp, libc++, libandroid-stub, libprotobuf"
TERMUX_PKG_SRCURL="https://github.com/tareksander/termux-gui-c-bindings/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=7781fdbd37ca1376b4c2339440976b0aa00cc2188592ea51438e473589db466f
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"

termux_step_pre_configure() {
	termux_setup_protobuf
	export SHARED_BUILD=1
}
