TERMUX_PKG_HOMEPAGE=https://github.com/nemtrif/utfcpp
TERMUX_PKG_DESCRIPTION="UTF8-CPP: UTF-8 with C++ in a Portable Way"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_VERSION=3.1.1
TERMUX_PKG_SRCURL=https://github.com/nemtrif/utfcpp/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=33496a4c3cc2de80e9809c4997052331af5fb32079f43ab4d667cd48c3a36e88
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_configure() {
	return 0;
}

termux_step_make_install(){
	cp -r source/* $TERMUX_PREFIX/include/
}
