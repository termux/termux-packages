TERMUX_PKG_HOMEPAGE=https://github.com/PortMidi/portmidi
TERMUX_PKG_DESCRIPTION="A cross-platform MIDI input/output library"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.0.6"
TERMUX_PKG_SRCURL=https://github.com/PortMidi/portmidi/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=81d22b34051621cd56c8d5ef12908ef2a59764c9cdfba6dae47aabddb71ac914
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DLINUX_DEFINES=PMNULL
"

termux_step_post_massage() {
	cd ${TERMUX_PKG_MASSAGEDIR}/${TERMUX_PREFIX}/lib || exit 1
	if [ ! -e "./libporttime.so" ]; then
		ln -sf libportmidi.so libporttime.so
	fi
}
