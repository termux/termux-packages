TERMUX_PKG_HOMEPAGE=https://github.com/Genymobile/scrcpy
TERMUX_PKG_DESCRIPTION="Provides display and control of Android devices connected via USB or over TCP/IP"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.1
TERMUX_PKG_SRCURL=https://github.com/Genymobile/scrcpy/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=57a277238d19d3471f37003d0d567bb8cde0a2b487b5cf91416129b463d9e8d5
TERMUX_PKG_DEPENDS="ffmpeg, libusb, sdl2"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dprebuilt_server=$TERMUX_PKG_SRCDIR/scrcpy-server-v${TERMUX_PKG_VERSION}
"

termux_step_post_get_source() {
	local _url=https://github.com/Genymobile/scrcpy/releases/download/v${TERMUX_PKG_VERSION}/scrcpy-server-v${TERMUX_PKG_VERSION}
	local _sha256=5b8bf1940264b930c71a1c614c57da2247f52b2d4240bca865cc6d366dff6688
	termux_download ${_url} $(basename ${_url}) ${_sha256}
}
