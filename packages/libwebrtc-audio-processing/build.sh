TERMUX_PKG_HOMEPAGE=https://www.freedesktop.org/software/pulseaudio/webrtc-audio-processing/
TERMUX_PKG_DESCRIPTION="A library containing the AudioProcessing module from the WebRTC project"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.3
TERMUX_PKG_SRCURL=https://www.freedesktop.org/software/pulseaudio/webrtc-audio-processing/webrtc-audio-processing-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=95552fc17faa0202133707bbb3727e8c2cf64d4266fe31bfdb2298d769c1db75
TERMUX_PKG_DEPENDS="libc++, abseil-cpp"

termux_step_pre_configure() {
	LDFLAGS+=" $($CC -print-libgcc-file-name)"
}
