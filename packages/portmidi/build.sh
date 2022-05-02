TERMUX_PKG_HOMEPAGE=https://github.com/PortMidi/portmidi
TERMUX_PKG_DESCRIPTION="A cross-platform MIDI input/output library"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.0.3
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/PortMidi/portmidi/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=934f80e1b09762664d995e7ab5a9932033bc70639e8ceabead817183a54c60d0
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DLINUX_DEFINES=PMNULL
"

termux_step_post_massage() {
	cd ${TERMUX_PKG_MASSAGEDIR}/${TERMUX_PREFIX}/lib || exit 1
	if [ ! -e "./libporttime.so" ]; then
		ln -sf libportmidi.so libporttime.so
	fi
}
