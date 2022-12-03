TERMUX_PKG_HOMEPAGE=https://github.com/Genymobile/scrcpy
TERMUX_PKG_DESCRIPTION="Provides display and control of Android devices connected via USB or over TCP/IP"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.24
TERMUX_PKG_SRCURL=https://github.com/Genymobile/scrcpy/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=e3054ad453ac577b941f8df0eabc94e842affc6e1d10ba8d21cededfa2eacc73
TERMUX_PKG_DEPENDS="ffmpeg, libusb, sdl2"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dprebuilt_server=$TERMUX_PKG_SRCDIR/scrcpy-server-v${TERMUX_PKG_VERSION}
"

termux_step_post_get_source() {
	local _url=https://github.com/Genymobile/scrcpy/releases/download/v${TERMUX_PKG_VERSION}/scrcpy-server-v${TERMUX_PKG_VERSION}
	local _sha256=ae74a81ea79c0dc7250e586627c278c0a9a8c5de46c9fb5c38c167fb1a36f056
	termux_download ${_url} $(basename ${_url}) ${_sha256}
}
