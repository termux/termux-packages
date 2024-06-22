TERMUX_PKG_HOMEPAGE=https://github.com/mstorsjo/fdk-aac
TERMUX_PKG_DESCRIPTION="Fraunhofer FDK AAC Codec Library"
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.0.3"
TERMUX_PKG_SRCURL=https://github.com/mstorsjo/fdk-aac/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=e25671cd96b10bad896aa42ab91a695a9e573395262baed4e4a2ff178d6a3a78
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
TERMUX_PKG_LICENSE_FILE=NOTICE

termux_step_pre_configure() {
	./autogen.sh
}
