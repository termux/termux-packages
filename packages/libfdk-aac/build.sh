# Contributor: @DLC01
TERMUX_PKG_HOMEPAGE=https://github.com/mstorsjo/fdk-aac
TERMUX_PKG_DESCRIPTION="Fraunhofer FDK AAC Codec Library"
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.0.0"
TERMUX_PKG_SRCURL=https://github.com/mstorsjo/fdk-aac/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=8538ea8f0f9915e460c106a13e1866a9e13c7ee48c1b67d0b2cf7b4e8159bd1a
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
TERMUX_PKG_LICENSE_FILE=NOTICE

termux_step_pre_configure() {
	./autogen.sh
}
