TERMUX_PKG_HOMEPAGE=https://source.android.com/devices/graphics/arch-vulkan
TERMUX_PKG_DESCRIPTION="Vulkan Loader for Android"
TERMUX_PKG_LICENSE="NCSA"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=$TERMUX_NDK_VERSION
TERMUX_PKG_SKIP_SRC_EXTRACT=true

# Desktop Vulkan Loader
# https://github.com/KhronosGroup/Vulkan-Loader
# https://github.com/KhronosGroup/Vulkan-Loader/blob/master/loader/LoaderAndLayerInterface.md

# Android Vulkan Loader
# https://source.android.com/devices/graphics/arch-vulkan
# https://android.googlesource.com/platform/frameworks/native/+/master/vulkan

# They are incompatible with each other and maintained by different
# organisations
# For now this package provides the NDK stub libvulkan.so
# The package will symbolic link system provided libvulkan.so to Termux Prefix
# if available

termux_step_extract_into_massagedir() {
	mkdir -p "$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/lib"
	if [ "$TERMUX_ARCH" = "aarch64" ]; then
		_ARCH="arm64"
	elif [ "$TERMUX_ARCH" = "i686" ]; then
		_ARCH="x86"
	else
		_ARCH="$TERMUX_ARCH"
	fi
	# aarch64 dont follow the lib64 trend or
	# x86_64 dont follow the lib trend
	if [ "$TERMUX_ARCH" = "x86_64" ]; then _BITS=64; else _BITS=""; fi
	cp "$NDK/platforms/android-${TERMUX_PKG_API_LEVEL}/arch-${_ARCH}/usr/lib${_BITS}/libvulkan.so" \
		"$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/lib/libvulkan.so"
	unset _ARCH
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
