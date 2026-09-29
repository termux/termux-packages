TERMUX_PKG_HOMEPAGE=https://github.com/PortMidi/portmidi
TERMUX_PKG_DESCRIPTION="A cross-platform MIDI input/output library"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.0.7"
TERMUX_PKG_SRCURL=https://github.com/PortMidi/portmidi/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=43fa65b4ed7ebaa68b0028a538ba8b2ca4dc9b86a7e22ec48842070e010f823f
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
