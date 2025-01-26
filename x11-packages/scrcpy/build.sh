TERMUX_PKG_HOMEPAGE=https://github.com/Genymobile/scrcpy
TERMUX_PKG_DESCRIPTION="Provides display and control of Android devices connected via USB or over TCP/IP"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.1"
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/Genymobile/scrcpy/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=beaa5050a3c45faa77cedc70ad13d88ef26b74d29d52f512b7708671e037d24d
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="android-tools, ffmpeg, libusb, sdl2 | sdl2-compat"
TERMUX_PKG_ANTI_BUILD_DEPENDS="android-tools, sdl2-compat"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dprebuilt_server=$TERMUX_PKG_SRCDIR/scrcpy-server-v${TERMUX_PKG_VERSION}
"

termux_step_post_get_source() {
	local _url=https://github.com/Genymobile/scrcpy/releases/download/v${TERMUX_PKG_VERSION}/scrcpy-server-v${TERMUX_PKG_VERSION}
	termux_download ${_url} $(basename ${_url}) SKIP_CHECKSUM
	# We are skipping checksum checking, but we should ensure it is android package.
	[[ "$(file $(basename ${_url}))"==*"Android package"*  || "$(file $(basename ${_url}))"==*"Zip archive data"* ]] \
		|| termux_error_exit "$(basename ${_url}) has wrong signature: $(file $(basename ${_url}))"
}
