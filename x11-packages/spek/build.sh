TERMUX_PKG_HOMEPAGE=http://spek.cc/
TERMUX_PKG_DESCRIPTION="An acoustic spectrum analyser"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.8.5
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/alexkay/spek/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=9053d2dec452dcde421daa0f5f59a9dee47927540f41d9c0c66800cb6dbf6996
TERMUX_PKG_DEPENDS="ffmpeg, libc++, wxwidgets"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_cv_path_WX_CONFIG_PATH=$TERMUX_PREFIX/bin/wx-config"

termux_step_pre_configure() {
	mkdir -p m4
	cp $TERMUX_PREFIX/share/aclocal/wxwin.m4 m4/
	NOCONFIGURE=1 sh autogen.sh
}
