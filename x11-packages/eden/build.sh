TERMUX_PKG_HOMEPAGE=https://eden-emu.dev/
TERMUX_PKG_DESCRIPTION="An open-source Nintendo Switch emulator"
TERMUX_PKG_LICENSE="GPL-3.0-or-later"
TERMUX_PKG_MAINTAINER="@IntinteDAO"
TERMUX_PKG_VERSION="0.2.1"
TERMUX_PKG_SRCURL=https://git.eden-emu.dev/eden-emu/eden/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=a43ea2886b75204438f691a4ddfad99e88b508e30431978dd13fba1c22440d19
TERMUX_PKG_DEPENDS="boost, dbus, ffmpeg, fmt, libandroid-shmem, libandroid-spawn, libenet, liblz4, libusb, libva, libzip, nlohmann-json, openssl, qt6-qtbase, qt6-qtcharts, qt6-qtmultimedia, qt6-qtsvg, qt6-qttools, qt6-qtwebengine, sdl2, shaderc, vulkan-headers, vulkan-loader, zlib, zstd"
TERMUX_PKG_BUILD_DEPENDS="catch2, extra-cmake-modules, glslang, pkg-config, qt6-qtbase-cross-tools, qt6-qttools-cross-tools"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXCLUDED_ARCHES="arm, i686"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DCPM_USE_LOCAL_PACKAGES=ON
-DENABLE_QT_TRANSLATION=ON
-Dhttplib_FORCE_BUNDLED=ON
-DVulkanHeaders_FORCE_BUNDLED=ON
-DVulkanUtilityLibraries_FORCE_BUNDLED=ON
-DUSE_AAUDIO=OFF
-DENABLE_AAUDIO=OFF
-DUSE_DISCORD_PRESENCE=OFF
-DYUZU_CHECK_SUBMODULES=OFF
-DYUZU_TESTS=OFF
-DDYNARMIC_TESTS=OFF
-DBUILD_TESTING=OFF
-DYUZU_USE_BUNDLED_FFMPEG=OFF
-DYUZU_USE_BUNDLED_QT=OFF
-DYUZU_USE_BUNDLED_SDL2=OFF
-DYUZU_USE_EXTERNAL_SDL2=OFF
-DYUZU_USE_QT_MULTIMEDIA=ON
-DYUZU_USE_QT_WEB_ENGINE=ON
"

termux_step_pre_configure() {
	CFLAGS+=" -flto=thin"
	CXXFLAGS+=" -flto=thin"
	LDFLAGS+=" -flto=thin -landroid-shmem -landroid-spawn"
}
