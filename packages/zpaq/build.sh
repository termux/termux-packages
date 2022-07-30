TERMUX_PKG_HOMEPAGE=http://mattmahoney.net/dc/zpaq.html
TERMUX_PKG_DESCRIPTION="Programmable file compressor, library and utilities. Based on the PAQ compression algorithm"
TERMUX_PKG_LICENSE="MIT, Unlicense"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=7.15
TERMUX_PKG_REVISION=0
TERMUX_PKG_SRCURL=https://github.com/zpaq/zpaq/archive/refs/tags/${TERMUX_PKG_VERSION}.zip
TERMUX_PKG_SHA256=2d13de90fdd89a8e9eeda4afbf76610d3ace4aa675795b7c3a9f13b21fbdbe3e
TERMUX_PKG_BUILD_DEPENDS="perl"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	CXXFLAGS+=" -O3"
	if [ $TERMUX_ARCH = "aarch64" ]; then
		CPPFLAGS+=" -DNOJIT"
	elif [ $TERMUX_ARCH = "arm" ]; then
		CPPFLAGS+=" -DNOJIT"
	elif [ $TERMUX_ARCH = "i686" ]; then
		CPPFLAGS+=" -Dunix"
	elif [ $TERMUX_ARCH = "x86_64" ]; then
		CPPFLAGS+=" -Dunix"
	fi
}
