TERMUX_PKG_HOMEPAGE=https://github.com/openstreetmap/OSM-binary/
TERMUX_PKG_DESCRIPTION="osmpbf is a Java/C library to read and write OpenStreetMap PBF files"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.5.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/openstreetmap/OSM-binary/archive/v${TERMUX_PKG_VERSION}.zip
TERMUX_PKG_SHA256=6738a5684bb68e3f890adda1b4116a6e04df9953d96788192052be53921107cd
TERMUX_PKG_DEPENDS="libprotobuf"
TERMUX_PKG_GROUPS="science"

termux_step_pre_configure() {
  termux_setup_protobuf
}
