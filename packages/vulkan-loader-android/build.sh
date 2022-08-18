TERMUX_PKG_HOMEPAGE=https://source.android.com/devices/graphics/arch-vulkan
TERMUX_PKG_DESCRIPTION="Vulkan Loader for Android"
TERMUX_PKG_LICENSE="NCSA"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=$TERMUX_NDK_VERSION
TERMUX_PKG_REVISION=2
TERMUX_PKG_SKIP_SRC_EXTRACT=true

# Desktop Vulkan Loader
# https://github.com/KhronosGroup/Vulkan-Loader
# https://github.com/KhronosGroup/Vulkan-Loader/blob/master/loader/LoaderAndLayerInterface.md

# Android Vulkan Loader
# https://source.android.com/devices/graphics/arch-vulkan
# https://android.googlesource.com/platform/frameworks/native/+/master/vulkan

# Vulkan functions exported by Android Vulkan Loader depending on API version
# https://android.googlesource.com/platform/frameworks/native/+/master/vulkan/libvulkan/libvulkan.map.txt

# For now this package provides the NDK stub libvulkan.so
# The package will symbolic link system provided libvulkan.so to Termux Prefix
# if available

termux_step_post_make_install() {
	cp -fv "$TERMUX_STANDALONE_TOOLCHAIN/sysroot/usr/lib/$TERMUX_HOST_PLATFORM/$TERMUX_PKG_API_LEVEL/libvulkan.so" \
		"$TERMUX_PREFIX/lib/libvulkan.so"
}

termux_step_create_debscripts() {
	if [ "$TERMUX_ARCH_BITS" = 64 ]; then _BITS=64; else _BITS=""; fi
	cat <<- EOF > postinst
	#!$TERMUX_PREFIX/bin/sh
	if [ -e /system/lib${_BITS}/libvulkan.so ]; then
		echo "Symlink /system/lib${_BITS}/libvulkan.so to $TERMUX_PREFIX/lib/libvulkan.so ..."
		ln -fsT "/system/lib${_BITS}/libvulkan.so" "$TERMUX_PREFIX/lib/libvulkan.so"
	fi
	EOF

	cat <<- EOF > postrm
	#!$TERMUX_PREFIX/bin/sh
	rm -f "$TERMUX_PREFIX/lib/libvulkan.so"
	EOF
	unset _BITS
}
