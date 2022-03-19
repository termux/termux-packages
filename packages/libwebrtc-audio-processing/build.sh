TERMUX_PKG_HOMEPAGE=https://freedesktop.org/software/pulseaudio/webrtc-audio-processing/
TERMUX_PKG_DESCRIPTION="A library containing the AudioProcessing module from the WebRTC project"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="Patrick Gaskin @pgaskin"
TERMUX_PKG_VERSION=0.3.1
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://freedesktop.org/software/pulseaudio/webrtc-audio-processing/webrtc-audio-processing-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=4dabdd0789acd117d88d53f0a793cf4e906c6a93ee9aa6975ec928eafbf1dfe5
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	LDFLAGS+=" $($CC -print-libgcc-file-name)"
}
