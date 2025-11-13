TERMUX_PKG_HOMEPAGE=https://www.freerdp.com/
TERMUX_PKG_DESCRIPTION="A free remote desktop protocol library and clients"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.18.0"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/FreeRDP/FreeRDP/archive/refs/tags/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=d2ec022566fa523ef33c29db952d428eb0ddc0a7b7f36204499fd06185178e5e
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libandroid-shmem, libcairo, libicu, libjpeg-turbo, libusb, libwayland, libx11, libxcursor, libxdamage, libxext, libxfixes, libxi, libxinerama, libxkbcommon, libxkbfile, libxrandr, libxrender, libxv, openssl, pulseaudio, zlib"
TERMUX_PKG_BUILD_DEPENDS="libwayland-cross-scanner, libwayland-protocols"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DANDROID_NO_TERMUX=OFF
-DWITH_LIBSYSTEMD=OFF
-DWITH_PULSE=ON
-DWITH_OPENSLES=OFF
-DWITH_OSS=OFF
-DWITH_ALSA=OFF
-DWITH_CUPS=OFF
-DWITH_PCSC=OFF
-DWITH_FFMPEG=OFF
-DWITH_JPEG=ON
-DWITH_OPENSSL=ON
-DWITH_SERVER=ON
-DWITH_OPUS=OFF
-DWITH_SWSCALE=OFF
-DWITH_FUSE=OFF
-DWITH_KRB5=OFF
"

termux_step_post_get_source() {
	find "$TERMUX_PKG_SRCDIR" -name CMakeLists.txt -o -name '*.cmake' | \
		xargs -n 1 sed -i \
		-e 's/\([^A-Za-z0-9_]ANDROID\)\([^A-Za-z0-9_]\)/\1_NO_TERMUX\2/g' \
		-e 's/\([^A-Za-z0-9_]ANDROID\)$/\1_NO_TERMUX/g'
}

termux_step_pre_configure() {
	termux_setup_wayland_cross_pkg_config_wrapper

	CFLAGS+=" -Wno-incompatible-function-pointer-types"
	CPPFLAGS+=" -D__USE_BSD"
	LDFLAGS+=" -landroid-shmem"
}

termux_step_post_configure() {
	mkdir -p "${TERMUX_PKG_TMPDIR}/bin"
	clang "${TERMUX_PKG_SRCDIR}/client/common/man/generate_argument_manpage.c" -o "${TERMUX_PKG_TMPDIR}/bin/generate_argument_manpage" -fno-sanitize=all \
		-I"${TERMUX_PKG_BUILDDIR}/include" -I"${TERMUX_PKG_BUILDDIR}/winpr/include" -I"${TERMUX_PKG_SRCDIR}/winpr/include"
	PATH+=":${TERMUX_PKG_TMPDIR}/bin"
}
