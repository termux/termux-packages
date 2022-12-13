TERMUX_PKG_HOMEPAGE=https://chromium.googlesource.com/angle/angle
TERMUX_PKG_DESCRIPTION="A conformant OpenGL ES implementation for Windows, Mac, Linux, iOS and Android"
TERMUX_PKG_LICENSE="BSD 3-Clause, Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
# Angle does not create release tarballs or tag specific revisions as releases.
# Every time we use `fetch angle` to get source, it will get the latest main branch.
# See https://github.com/google/angle/blob/main/doc/ChoosingANGLEBranch.md.
_COMMIT_DATE=2022.12.10
TERMUX_PKG_SRCURL=https://github.com/google/angle.git
TERMUX_PKG_VERSION=0.0.${_COMMIT_DATE//./}.0
TERMUX_PKG_DEPENDS="glib, libandroid-shmem, libc++, libwayland, libx11, libxcb, libxi, libxext, swiftshader"

termux_step_get_source() {
	# Check whether we need to get source
	if [ -f "$TERMUX_PKG_CACHEDIR/.angle-source-fetched" ]; then
		local _fetched_source_version=$(cat $TERMUX_PKG_CACHEDIR/.angle-source-fetched)
		if [ "$_fetched_source_version" = "$TERMUX_PKG_VERSION" ]; then
			echo "[INFO]: Use pre-fetched source (version $_fetched_source_version)."
			ln -sfr $TERMUX_PKG_CACHEDIR/tmp-checkout $TERMUX_PKG_SRCDIR
			# Revert patches
			shopt -s nullglob
			local f
			for f in $TERMUX_PKG_BUILDER_DIR/*.patch; do
				echo "[INFO]: Reverting $(basename "$f")"
				(sed "s|@TERMUX_PREFIX@|$TERMUX_PREFIX|g" "$f" | patch -f --silent -R -p1 -d "$TERMUX_PKG_SRCDIR") || true
			done
			shopt -u nullglob
			return
		fi
	fi

	# Fetch depot_tools
	if [ ! -f "$TERMUX_PKG_CACHEDIR/.depot_tools-fetched" ];then
		git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git $TERMUX_PKG_CACHEDIR/depot_tools
		touch "$TERMUX_PKG_CACHEDIR/.depot_tools-fetched"
	fi
	export PATH="$TERMUX_PKG_CACHEDIR/depot_tools:$PATH"

	# Get source
	rm -rf "$TERMUX_PKG_CACHEDIR/tmp-checkout"
	mkdir -p "$TERMUX_PKG_CACHEDIR/tmp-checkout"
	pushd "$TERMUX_PKG_CACHEDIR/tmp-checkout"
	fetch --nohistory angle --checkout_android=False --checkout_chromeos=False || bash
	popd

	echo "$TERMUX_PKG_VERSION" > "$TERMUX_PKG_CACHEDIR/.angle-source-fetched"
	ln -sfr $TERMUX_PKG_CACHEDIR/tmp-checkout $TERMUX_PKG_SRCDIR
}

termux_step_configure() {
	cd $TERMUX_PKG_SRCDIR
	termux_setup_gn
	termux_setup_ninja
	termux_setup_nodejs

	# Remove termux's dummy pkg-config
	local _host_pkg_config="$(cat $(command -v pkg-config) | grep exec | awk '{print $2}')"
	rm -rf $TERMUX_PKG_TMPDIR/host-pkg-config-bin
	mkdir -p $TERMUX_PKG_TMPDIR/host-pkg-config-bin
	ln -s $_host_pkg_config $TERMUX_PKG_TMPDIR/host-pkg-config-bin
	export PATH="$TERMUX_PKG_TMPDIR/host-pkg-config-bin:$PATH"

	# Dummy librt.so
	echo "INPUT(-landroid-shmem -llog)" > "$TERMUX_PREFIX/lib/librt.so"

	# Dummy libpthread.a
	echo '!<arch>' > "$TERMUX_PREFIX/lib/libpthread.a"

	# Merge sysroots
	rm -rf $TERMUX_PKG_TMPDIR/sysroot
	mkdir -p $TERMUX_PKG_TMPDIR/sysroot
	pushd $TERMUX_PKG_TMPDIR/sysroot
	mkdir -p usr/include usr/lib usr/bin
	cp -R $TERMUX_STANDALONE_TOOLCHAIN/sysroot/usr/include/* usr/include
	cp -R $TERMUX_STANDALONE_TOOLCHAIN/sysroot/usr/include/$TERMUX_HOST_PLATFORM/* usr/include
	cp -R $TERMUX_STANDALONE_TOOLCHAIN/sysroot/usr/lib/$TERMUX_HOST_PLATFORM/$TERMUX_PKG_API_LEVEL/* usr/lib/
	cp "$TERMUX_STANDALONE_TOOLCHAIN/sysroot/usr/lib/$TERMUX_HOST_PLATFORM/libc++_shared.so" usr/lib/
	cp "$TERMUX_STANDALONE_TOOLCHAIN/sysroot/usr/lib/$TERMUX_HOST_PLATFORM/libc++_static.a" usr/lib/
	cp "$TERMUX_STANDALONE_TOOLCHAIN/sysroot/usr/lib/$TERMUX_HOST_PLATFORM/libc++abi.a" usr/lib/
	cp -Rf $TERMUX_PREFIX/include/* usr/include
	cp -Rf $TERMUX_PREFIX/lib/* usr/lib
	ln -sf /data ./data
	# Remove EGL headers
	rm -rf usr/include/EGL
	popd

	local _TARGET_CPU="$TERMUX_ARCH"
	if [ "$TERMUX_ARCH" = "aarch64" ]; then
		_TARGET_CPU="arm64"
	elif [ "$TERMUX_ARCH" = "x86_64" ]; then
		_TARGET_CPU="x64"
	elif [ "$TERMUX_ARCH" = "i686" ]; then
		_TARGET_CPU="x86"
	fi

	local _common_args_file=$TERMUX_PKG_TMPDIR/common-args-file
	rm -f $_common_args_file
	touch $_common_args_file

	echo "
use_sysroot = true
target_cpu = \"$_TARGET_CPU\"
target_rpath = \"$TERMUX_PREFIX/lib\"
target_sysroot = \"$TERMUX_PKG_TMPDIR/sysroot\"
custom_toolchain = \"//build/toolchain/linux/unbundle:default\"
is_official_build = true
is_cfi = false
clang_base_path = \"$TERMUX_STANDALONE_TOOLCHAIN\"
clang_use_chrome_plugins = false
dcheck_always_on = false
chrome_pgo_phase = 0
treat_warnings_as_errors = false
use_custom_libcxx = false
use_udev = false
use_libpci = false
# Do not build tests
angle_build_tests = false
# Use X11 and Wayland
use_ozone = true
ozone_platform_x11 = true
ozone_platform_wayland = true
angle_use_x11 = true
angle_use_wayland = true
# Disable all backends except Vulkan
angle_enable_vulkan = true
angle_enable_gl = false
angle_enable_d3d9 = false
angle_enable_d3d11 = false
angle_enable_null = false
angle_enable_metal = false
# Enable swiftshader
angle_enable_swiftshader = true
# Enable Vulkan validation layer
angle_enable_vulkan_validation_layers = true
# Disable all shader translator targets except desktop GL (for Vulkan)
angle_enable_essl = false
angle_enable_glsl = false
angle_enable_hlsl = false
angle_enable_gl_desktop_frontend = true
# Disable histogram/protobuf support
angle_has_histograms = false
" > $_common_args_file

	# For arm, tell GN the float abi rather than let it detect.
	if [ "$TERMUX_ARCH" = "arm" ]; then
		echo "arm_arch = \"armv7-a\"" >> $_common_args_file
		echo "arm_float_abi = \"softfp\"" >> $_common_args_file
	fi

	# When building for x64, these variables must be set to tell
	# GN that we are at cross-compiling.
	if [ "$TERMUX_ARCH" = "x86_64" ]; then
		mkdir -p $TERMUX_PKG_TMPDIR/host-toolchain
		local _sysroot_path="$(pwd)/build/linux/$(ls build/linux | grep 'amd64-sysroot')"
		pushd $TERMUX_PKG_TMPDIR/host-toolchain
		sed "s|@COMPILER@|$(command -v clang-13)|" $TERMUX_PKG_BUILDER_DIR/wrapper-compiler.in |
			sed "s|@NEW_SYSROOT@|$_sysroot_path|;s|@TERMUX_PREFIX@|$TERMUX_PREFIX|" > ./wrapper_cc
		sed "s|@COMPILER@|$(command -v clang++-13)|" $TERMUX_PKG_BUILDER_DIR/wrapper-compiler.in |
			sed "s|@NEW_SYSROOT@|$_sysroot_path|;s|@TERMUX_PREFIX@|$TERMUX_PREFIX|" > ./wrapper_cxx
		chmod +x ./wrapper_cc ./wrapper_cxx
		popd

		export BUILD_CC=$TERMUX_PKG_TMPDIR/host-toolchain/wrapper_cc
		export BUILD_CXX=$TERMUX_PKG_TMPDIR/host-toolchain/wrapper_cxx
		export BUILD_AR=$(command -v llvm-ar)
		export BUILD_NM=$(command -v llvm-nm)

		export BUILD_CFLAGS="--target=x86_64-linux-gnu"
		export BUILD_CPPFLAGS=""
		export BUILD_CXXFLAGS="--target=x86_64-linux-gnu"
		export BUILD_LDFLAGS="--target=x86_64-linux-gnu"

		echo "host_toolchain = \"//build/toolchain/linux/unbundle:host\"" >> $_common_args_file
	fi

	mkdir -p $TERMUX_PKG_BUILDDIR/out/Release
	cat $_common_args_file > $TERMUX_PKG_BUILDDIR/out/Release/args.gn
	gn gen $TERMUX_PKG_BUILDDIR/out/Release --export-compile-commands
}

termux_step_make() {
	cd $TERMUX_PKG_BUILDDIR
	ninja -C $TERMUX_PKG_BUILDDIR/out/Release
}

termux_step_make_install() {
	cd $TERMUX_PKG_BUILDDIR
	mkdir -p $TERMUX_PREFIX/lib/angle
	local libraries=(
		# libANGLE
		libEGL.so
		libEGL_vulkan_secondaries.so
		libGLESv1_CM.so
		libGLESv2.so
		libGLESv2_vulkan_secondaries.so
		libGLESv2_with_capture.so
		libfeature_support.so
		libVkICD_mock_icd.so
		libVkLayer_khronos_validation.so
		
		# SwiftShader
		libvulkan.so.1
		libvk_swiftshader.so
	)

	# Libraries
	cp "${libraries[@]/#/out/Release/}" "$TERMUX_PREFIX/lib/angle/"
	cp -Rf out/Release/angledata $TERMUX_PREFIX/lib/angle/

	# Translator
	cp out/Release/angle_shader_translator $TERMUX_PREFIX/bin/angle_shader_translator

	# Symlinks
	ln -sfr $TERMUX_PREFIX/lib/angle/libEGL.so $TERMUX_PREFIX/lib
	ln -sfr libEGL.so $TERMUX_PREFIX/lib/libEGL.so.1
	ln -sfr $TERMUX_PREFIX/lib/angle/libGLESv1_CM.so $TERMUX_PREFIX/lib
	ln -sfr libGLESv1_CM.so $TERMUX_PREFIX/lib/libGLESv1_CM.so.1
	ln -sfr $TERMUX_PREFIX/lib/angle/libGLESv2.so $TERMUX_PREFIX/lib
	ln -sfr libGLESv2.so $TERMUX_PREFIX/lib/libGLESv2.so.2

	# SwiftShader
	ln -sfr $TERMUX_PREFIX/lib/angle/libvk_swiftshader.so $TERMUX_PREFIX/lib
	ln -sfr $TERMUX_PREFIX/lib/angle/libvulkan.so.1 $TERMUX_PREFIX/lib
	ln -sfr $TERMUX_PREFIX/lib/libvulkan.so.1 $TERMUX_PREFIX/lib/libvulkan.so
	mkdir -p $TERMUX_PREFIX/share/vulkan/icd.d
	sed "s|./libvk_swiftshader.so|$TERMUX_PREFIX/lib/angle/libvk_swiftshader.so|" \
		out/Release/vk_swiftshader_icd.json > $TERMUX_PREFIX/share/vulkan/icd.d/vk_swiftshader_icd.json

	# EGL headers
	mkdir -p $TERMUX_PREFIX/include/EGL
	cp -Rf $TERMUX_PKG_SRCDIR/include/EGL/* $TERMUX_PREFIX/include/EGL
}

termux_step_post_make_install() {
	# Remove the dummy files
	rm $TERMUX_PREFIX/lib/libpthread.a
	rm $TERMUX_PREFIX/lib/librt.so
}
