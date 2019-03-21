TERMUX_PKG_HOMEPAGE=https://github.com/nemtrif/utfcpp
TERMUX_PKG_DESCRIPTION="UTF8-CPP: UTF-8 with C++ in a Portable Way"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_VERSION=2.3.5
TERMUX_PKG_SHA256=f3ffe0ef6c02f48ebafe42369cbd741e844143baad27c13baad1cd14b863983d
TERMUX_PKG_SRCURL=https://github.com/nemtrif/utfcpp/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_NO_DEVELSPLIT=yes

termux_step_configure() {
	return 0;
}

termux_step_make_install(){
	cp -r source/* $TERMUX_PREFIX/include/
}
