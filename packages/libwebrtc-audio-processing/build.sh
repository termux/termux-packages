TERMUX_PKG_HOMEPAGE=https://www.freedesktop.org/software/pulseaudio/webrtc-audio-processing/
TERMUX_PKG_DESCRIPTION="A library containing the AudioProcessing module from the WebRTC project"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.1"
TERMUX_PKG_SRCURL="https://www.freedesktop.org/software/pulseaudio/webrtc-audio-processing/webrtc-audio-processing-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=35e86b986d02ea15f3d04741a1a5a735ba399bc0fac0ee089c39480e35fc3253
TERMUX_PKG_DEPENDS="libc++, abseil-cpp"

termux_step_pre_configure() {
	LDFLAGS+=" $($CC -print-libgcc-file-name)"
}
