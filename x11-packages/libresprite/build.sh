TERMUX_PKG_HOMEPAGE=https://libresprite.github.io/
TERMUX_PKG_DESCRIPTION="Free and open source program for creating and animating sprites"
TERMUX_PKG_LICENSE="GPL-2.0-only"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.2"
TERMUX_PKG_SRCURL="https://github.com/LibreSprite/LibreSprite/releases/download/v$TERMUX_PKG_VERSION/SOURCE.CODE.+.submodules.tar.gz"
TERMUX_PKG_SHA256=38a2387694df9d5725244622d1c2e6cae8aced06b19c19cfbeab96afb13523c0
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_HOSTBUILD=true
# Unlike most SDL2 programs, it appears to actually work only with the real sdl2, not sdl2-compat
# error: "Failed loading SDL3 library.""
TERMUX_PKG_DEPENDS="freetype, giflib, libarchive, libjpeg-turbo, libpixman, libpng, libtinyxml2, libwebp, libxi, sdl2, sdl2-image, xdg-utils, zlib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_POLICY_VERSION_MINIMUM=3.5
-DWITH_WEBP_SUPPORT=ON
-DWITH_DESKTOP_INTEGRATION=ON
"

# The original "termux_extract_src_archive" always strips the first components
# but the source of libresprite is directly under the root directory of the tar file
termux_extract_src_archive() {
	local file="$TERMUX_PKG_CACHEDIR/$(basename "$TERMUX_PKG_SRCURL")"
	mkdir -p "$TERMUX_PKG_SRCDIR"
	tar -xf "$file" -C "$TERMUX_PKG_SRCDIR"
}

termux_step_host_build() {
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "true" ]]; then
		return
	fi

	termux_setup_cmake
	termux_setup_ninja

	termux_download_ubuntu_packages libtinyxml2-10 libtinyxml2-dev

	cmake "$TERMUX_PKG_SRCDIR" \
		-GNinja \
		-DGEN_ONLY=ON \
		-DUSE_SDL2_BACKEND=OFF \
		-DCMAKE_PREFIX_PATH="$TERMUX_PKG_HOSTBUILD_DIR/ubuntu_packages/usr" \
		-DCMAKE_POLICY_VERSION_MINIMUM=3.5
	ninja -j "$TERMUX_PKG_MAKE_PROCESSES"
}

termux_step_pre_configure() {
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "false" ]]; then
		PATH="$TERMUX_PKG_HOSTBUILD_DIR/bin:$PATH"
		local patch="$TERMUX_PKG_BUILDER_DIR/cross-compilation-use-hostbuilt-gen.diff"
		echo "Applying patch: $patch"
		patch -p1 -d "$TERMUX_PKG_SRCDIR" < "${patch}"
	fi
}
