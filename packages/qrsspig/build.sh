TERMUX_PKG_HOMEPAGE=https://gitlab.com/hb9fxx/qrsspig
TERMUX_PKG_DESCRIPTION="Headless QRSS grabber for Raspberry Pi's"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.8.1"
TERMUX_PKG_SRCURL="https://gitlab.com/hb9fxx/qrsspig/-/archive/v${TERMUX_PKG_VERSION}/qrsspig-v${TERMUX_PKG_VERSION}.tar.bz2"
TERMUX_PKG_SHA256=48dc05f04875734ecadfea481b62f4c44f87ead4d6b8f7083c8bfeee731c31fb
TERMUX_PKG_DEPENDS="boost, fftw, libc++, libcurl, libgd, libliquid-dsp, libssh, libyaml-cpp, pulseaudio"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_DEPENDS="boost-headers"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DCMAKE_POLICY_VERSION_MINIMUM=3.5"

termux_step_pre_configure() {
	LDFLAGS+=" -llog"
}

termux_step_post_make_install() {
	install -Dm600 -t $TERMUX_PREFIX/etc/qrsspig \
		$TERMUX_PKG_SRCDIR/etc/qrsspig.yaml
}
