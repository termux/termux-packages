TERMUX_PKG_HOMEPAGE=https://github.com/mstorsjo/fdk-aac
TERMUX_PKG_DESCRIPTION="Fraunhofer FDK AAC Codec Library"
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_MAINTAINER="@DLC01"
TERMUX_PKG_VERSION=2.0.2
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/mstorsjo/fdk-aac/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=7812b4f0cf66acda0d0fe4302545339517e702af7674dd04e5fe22a5ade16a90
TERMUX_PKG_LICENSE_FILE=NOTICE

termux_step_pre_configure() {
	./autogen.sh
}
