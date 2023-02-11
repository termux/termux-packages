TERMUX_PKG_HOMEPAGE=https://gitlab.com/hb9fxx/qrsspig
TERMUX_PKG_DESCRIPTION="Headless QRSS grabber for Raspberry Pi's"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.8.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://gitlab.com/hb9fxx/qrsspig/-/archive/v${TERMUX_PKG_VERSION}/qrsspig-v${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=9b3df7723944ef15f99d355ed071f41ace663833afe46703036ead89415372d1
TERMUX_PKG_DEPENDS="boost, fftw, libc++, libcurl, libgd, libliquid-dsp, libssh, libyaml-cpp, pulseaudio"
TERMUX_PKG_BUILD_DEPENDS="boost-headers"

termux_step_pre_configure() {
	LDFLAGS+=" -llog"
}

termux_step_post_make_install() {
	install -Dm600 -t $TERMUX_PREFIX/etc/qrsspig \
		$TERMUX_PKG_SRCDIR/etc/qrsspig.yaml
}
