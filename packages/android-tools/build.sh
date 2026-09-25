TERMUX_PKG_HOMEPAGE=https://developer.android.com/
TERMUX_PKG_DESCRIPTION="Android platform tools"
TERMUX_PKG_LICENSE="Apache-2.0, BSD 2-Clause"
TERMUX_PKG_LICENSE_FILE="LICENSE, vendor/core/fastboot/LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="37.0.0"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL="https://github.com/nmeum/android-tools/releases/download/${TERMUX_PKG_VERSION#*really}/android-tools-${TERMUX_PKG_VERSION#*really}.tar.xz"
TERMUX_PKG_SHA256=2725d09f892a3a38e534429f47a321f58ecf6a3169caa42c915fb2cb7d46be0e
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="abseil-cpp, brotli, fmt, libc++, liblz4, libprotobuf, pcre2, zlib, zstd"
TERMUX_PKG_BUILD_DEPENDS="googletest"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DANDROID_TOOLS_USE_BUNDLED_LIBUSB=ON
"

termux_step_pre_configure() {
	termux_setup_protobuf
	termux_setup_golang

	LDFLAGS+=" $($TERMUX_SCRIPTDIR/packages/libprotobuf/interface_link_libraries.sh)"
}

termux_step_post_make_install() {
	# Conflicts with the dedicated mkbootimg package's own bin/mkbootimg.
	rm -f "${TERMUX_PREFIX}/bin/mkbootimg"
}
