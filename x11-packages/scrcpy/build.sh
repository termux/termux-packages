TERMUX_PKG_HOMEPAGE=https://github.com/Genymobile/scrcpy
TERMUX_PKG_DESCRIPTION="Provides display and control of Android devices connected via USB or over TCP/IP"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="5.0.1-20261027"
TERMUX_PKG_SRCURL="https://github.com/Genymobile/scrcpy/archive/refs/tags/v${TERMUX_PKG_VERSION%-*}.tar.gz"
TERMUX_PKG_SHA256=a24b996ac23d0f674d3237c00b39a97829d8acbe9e1657a6c216fd51ea488ee5
TERMUX_PKG_DEPENDS="android-tools, ffmpeg, libusb, sdl3"
TERMUX_PKG_ANTI_BUILD_DEPENDS="android-tools"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dprebuilt_server=$TERMUX_PKG_BUILDDIR/server-build/scrcpy-server
"

termux_step_pre_configure() {
	BUILD_DIR="$TERMUX_PKG_BUILDDIR/server-build" \
	ANDROID_PLATFORM=35 \
	ANDROID_BUILD_TOOLS="$TERMUX_ANDROID_BUILD_TOOLS_VERSION" \
		./server/build_without_gradle.sh
}
