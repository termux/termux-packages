TERMUX_PKG_HOMEPAGE=https://www.mesa3d.org
TERMUX_PKG_DESCRIPTION="Mesa's Freedreno Vulkan ICD (SurfaceFlinger WSI)"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_LICENSE_FILE="docs/license.rst"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="26.0.6"
TERMUX_PKG_SRCURL="https://archive.mesa3d.org/mesa-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=1d3c3b8a8363b8cc354175bb4a684ad8b035211cc1d6fa17aeb9b9623c513f89
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_DEPENDS="zlib-static"
TERMUX_PKG_API_LEVEL=26
TERMUX_PKG_EXCLUDED_ARCHES="i686, x86_64"
# closely based on: https://docs.mesa3d.org/android.html#building-using-the-android-ndk
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--cmake-prefix-path $TERMUX_PREFIX
-Dplatforms=android
-Dplatform-sdk-version=$TERMUX_PKG_API_LEVEL
-Dandroid-stub=true
-Dandroid-libbacktrace=disabled
-Dgallium-drivers=
-Degl=disabled
-Dvulkan-drivers=freedreno
-Dfreedreno-kmds=kgsl
-Dzstd=disabled
"

termux_step_post_get_source() {
	# Do not use meson wrap projects
	rm -rf subprojects
}

termux_step_pre_configure() {
	export LDFLAGS+=" -l:libz.a -static-libstdc++"
}

termux_step_post_make_install() {
	local VK_HEADER_VERSION_MAJOR="$(grep VK_HEADER_VERSION_COMPLETE "$TERMUX_PKG_SRCDIR/src/vulkan/registry/vk.xml" | grep name | head -n1 | grep -o '[0-9]\+' | head -n2 | tail -n1)"
	local VK_HEADER_VERSION_MINOR="$(grep VK_HEADER_VERSION_COMPLETE "$TERMUX_PKG_SRCDIR/src/vulkan/registry/vk.xml" | grep name | head -n1 | grep -o '[0-9]\+' | tail -n1)"
	local VK_HEADER_VERSION_PATCH="$(grep VK_HEADER_VERSION "$TERMUX_PKG_SRCDIR/src/vulkan/registry/vk.xml" | grep name | head -n1 | grep -o '[0-9]\+')"
	local VK_HEADER_VERSION_COMPLETE="$VK_HEADER_VERSION_MAJOR.$VK_HEADER_VERSION_MINOR.$VK_HEADER_VERSION_PATCH"
	cat > meta.json <<-EOF
	{
		"schemaVersion": 1,
		"name": "Mesa Turnip Adreno Driver v$TERMUX_PKG_VERSION",
		"description": "$TERMUX_PKG_DESCRIPTION",
		"author": "$TERMUX_PKG_MAINTAINER",
		"packageVersion": "1",
		"vendor": "Mesa",
		"driverVersion": "$VK_HEADER_VERSION_COMPLETE",
		"minApi": $TERMUX_PKG_API_LEVEL,
		"libraryName": "libvulkan_freedreno_surfaceflinger.so"
	}
	EOF
	cp "$TERMUX_PREFIX/lib/libvulkan_freedreno_surfaceflinger.so" .
	"$STRIP" libvulkan_freedreno_surfaceflinger.so
	mkdir -p "$TERMUX_PREFIX/opt/adrenotools-drivers/"
	rm -f "$TERMUX_PREFIX/opt/adrenotools-drivers/turnip_v$TERMUX_PKG_VERSION.zip"
	zip "$TERMUX_PREFIX/opt/adrenotools-drivers/turnip_v$TERMUX_PKG_VERSION.zip" \
		libvulkan_freedreno_surfaceflinger.so \
		meta.json
}
