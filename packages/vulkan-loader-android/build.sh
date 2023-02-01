TERMUX_PKG_HOMEPAGE=https://source.android.com/devices/graphics/arch-vulkan
TERMUX_PKG_DESCRIPTION="Vulkan Loader for Android"
TERMUX_PKG_LICENSE="NCSA"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=25c
TERMUX_PKG_SRCURL=https://dl.google.com/android/repository/android-ndk-r${TERMUX_PKG_VERSION}-linux.zip
TERMUX_PKG_SHA256=769ee342ea75f80619d985c2da990c48b3d8eaf45f48783a2d48870d04b46108
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_BUILD_IN_SRC=true

# Desktop Vulkan Loader
# https://github.com/KhronosGroup/Vulkan-Loader
# https://github.com/KhronosGroup/Vulkan-Loader/blob/master/loader/LoaderAndLayerInterface.md

# Android Vulkan Loader
# https://source.android.com/devices/graphics/arch-vulkan
# https://android.googlesource.com/platform/frameworks/native/+/master/vulkan

# Vulkan functions exported by Android Vulkan Loader depending on API version
# https://android.googlesource.com/platform/frameworks/native/+/master/vulkan/libvulkan/libvulkan.map.txt

# For now this package provides the NDK stub libvulkan.so (Termux current minimum API verison)
# If system libvulkan.so is available, the stub will be replaced with symlink to system libvulkan.so

termux_step_host_build() {
	# it doesnt make sense to set vulkan.pc version to:
	# 1. vulkan-loader package version and bump this package every time the former updates
	# 2. NDK version since the stubs are the same between NDK releases AFAIK and isnt related to vulkan
	# so we use NDK provided vulkan header version but https://github.com/android/ndk/issues/1721
	# NDK shows that there is 2 different versions of vulkan headers
	cat <<- EOF > vulkan_header_version.c
	#include <stdio.h>
	#include "vulkan/vulkan_core.h"
	int main(void) {
		printf("%d.%d.%d\n",
			VK_HEADER_VERSION_COMPLETE >> 22,
			VK_HEADER_VERSION_COMPLETE >> 12 & 0x03ff,
			VK_HEADER_VERSION_COMPLETE & 0x0fff);
		return 0;
	}
	EOF
	rm -fr ./vulkan
	cp -fr "$TERMUX_PKG_SRCDIR/toolchains/llvm/prebuilt/linux-x86_64/sysroot/usr/include/vulkan" ./vulkan
	cc vulkan_header_version.c -o vulkan_header_version
}

termux_step_post_make_install() {
	install -v -Dm644 \
		"toolchains/llvm/prebuilt/linux-x86_64/sysroot/usr/lib/$TERMUX_HOST_PLATFORM/$TERMUX_PKG_API_LEVEL/libvulkan.so" \
		"$TERMUX_PREFIX/lib/libvulkan.so"

	local vulkan_loader_version
	vulkan_loader_version="$($TERMUX_PKG_HOSTBUILD_DIR/vulkan_header_version)"
	if [ -z "$vulkan_loader_version" ]; then
		termux_error_exit "ERROR: Host built vulkan_header_version is not printing version!"
	fi

	# based on https://github.com/KhronosGroup/Vulkan-Loader/blob/master/loader/vulkan.pc.in
	# not using "Libs.private"
	cat <<- EOF > "$TERMUX_PKG_TMPDIR/vulkan.pc"
	prefix=$TERMUX_PREFIX
	exec_prefix=\${prefix}
	libdir=\${exec_prefix}/lib
	includedir=\${prefix}/include
	Name: Vulkan-Loader
	Description: Vulkan Loader
	Version: $vulkan_loader_version
	Libs: -L\${libdir} -lvulkan
	Cflags: -I\${includedir}
	EOF
	install -Dm644 "$TERMUX_PKG_TMPDIR/vulkan.pc" "$TERMUX_PREFIX/lib/pkgconfig/vulkan.pc"
	echo "INFO: Printing vulkan.pc..."
	cat "$TERMUX_PREFIX/lib/pkgconfig/vulkan.pc"
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
