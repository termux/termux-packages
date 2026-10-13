TERMUX_PKG_HOMEPAGE=https://github.com/PortMidi/portmidi
TERMUX_PKG_DESCRIPTION="A cross-platform MIDI input/output library"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.0.8"
TERMUX_PKG_SRCURL=https://github.com/PortMidi/portmidi/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=f21201d4cc233638d7bb6ee29ee6dece54f6c9c1aeb7989bc978001caaf2f666
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
