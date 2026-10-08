TERMUX_PKG_HOMEPAGE=https://developer.android.com/
TERMUX_PKG_DESCRIPTION="Android platform tools"
TERMUX_PKG_LICENSE="Apache-2.0, BSD 2-Clause"
TERMUX_PKG_LICENSE_FILE="LICENSE, vendor/core/fastboot/LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="37.0.0p1"
TERMUX_PKG_SRCURL="https://github.com/nmeum/android-tools/releases/download/${TERMUX_PKG_VERSION#*really}/android-tools-${TERMUX_PKG_VERSION#*really}.tar.xz"
TERMUX_PKG_SHA256=2c6de1abe16b211c7d9f59276217e14fd9e0e18b20e331d3c84358f5dffd576e
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

termux_step_create_debscripts() {
	cat <<-EOF > ./postinst
		#!${TERMUX_PREFIX}/bin/sh
		${TERMUX_PREFIX}/bin/adb kill-server || :
		exit 0
	EOF
}
