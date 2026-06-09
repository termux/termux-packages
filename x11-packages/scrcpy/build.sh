TERMUX_PKG_HOMEPAGE=https://github.com/Genymobile/scrcpy
TERMUX_PKG_DESCRIPTION="Provides display and control of Android devices connected via USB or over TCP/IP"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.0"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL="https://github.com/Genymobile/scrcpy/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=a62bc2639e1d56b3e7ebaa20d8deb4947dd02954b3362bdebe2ef9f7eae41b00
TERMUX_PKG_DEPENDS="android-tools, ffmpeg, libusb, sdl3"
TERMUX_PKG_ANTI_BUILD_DEPENDS="android-tools"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dprebuilt_server=$TERMUX_PKG_SRCDIR/scrcpy-server-v${TERMUX_PKG_VERSION}
"

termux_step_post_get_source() {
	local scrcpy_server="scrcpy-server-v${TERMUX_PKG_VERSION}"
	local url="https://github.com/Genymobile/scrcpy/releases/download/v${TERMUX_PKG_VERSION}/${scrcpy_server}"
	termux_download "${url}" "$(basename "${url}")" SKIP_CHECKSUM

	# Ensure the `scrcpy-server-v*` is an Android package.
	case "$(file -b --mime-type "$(basename "$TERMUX_PKG_SRCDIR/${scrcpy_server}")")" in
		"application/vnd.android.package-archive");;
		*)
			file -b "$(basename "${scrcpy_server}")" >&2
			file --mime-type "$(basename "${scrcpy_server}")" >&2
			termux_error_exit "$(basename "${scrcpy_server}") doesn't seem to be an Android APK package."
		;;
	esac
}
