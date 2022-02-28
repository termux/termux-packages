TERMUX_PKG_HOMEPAGE=https://github.com/protobuf-c/protobuf-c
TERMUX_PKG_DESCRIPTION="Protocol buffers C library"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="Henrik Grimler @Grimler91"
TERMUX_PKG_VERSION=1.4.0
TERMUX_PKG_SRCURL=https://github.com/protobuf-c/protobuf-c/releases/download/v${TERMUX_PKG_VERSION}/protobuf-c-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=26d98ee9bf18a6eba0d3f855ddec31dbe857667d269bc0b6017335572f85bbcb
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++, libprotobuf, protobuf"
TERMUX_PKG_BREAKS="libprotobuf-c-dev"
TERMUX_PKG_REPLACES="libprotobuf-c-dev"

termux_step_pre_configure() {
	termux_setup_protobuf
	export PROTOC=$(command -v protoc)
}
