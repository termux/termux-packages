TERMUX_PKG_HOMEPAGE=https://github.com/fathyb/carbonyl
TERMUX_PKG_DESCRIPTION="Chromium based browser built to run in a terminal"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_LICENSE_FILE="license.md"
TERMUX_PKG_MAINTAINER="@licy183"
_CHROMIUM_VERSION=111.0.5563.146
TERMUX_PKG_VERSION=0.0.3
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=(https://github.com/fathyb/carbonyl/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz
					https://commondatastorage.googleapis.com/chromium-browser-official/chromium-$_CHROMIUM_VERSION.tar.xz)
TERMUX_PKG_SHA256=(bf421b9498a084a7cf2238a574d37d31b498d3e271fdb3dcf466e7ed6c80013d
					1e701fa31b55fa0633c307af8537b4dbf67e02d8cad1080c57d845ed8c48b5fe)
TERMUX_PKG_DEPENDS="atk, cups, dbus, fontconfig, gtk3, krb5, libc++, libdrm, libevdev, libxkbcommon, libminizip, libnss, libwayland, libx11, mesa, openssl, pango, pulseaudio, zlib"
TERMUX_PKG_BUILD_DEPENDS="carbonyl-host-tools, libnotify, libffi-static"
TERMUX_PKG_ON_DEVICE_BUILD_NOT_SUPPORTED=true
# Chromium doesn't support i686 on Linux.
# Carbonyl donesn't support arm.
TERMUX_PKG_BLACKLISTED_ARCHES="arm, i686"

SYSTEM_LIBRARIES="    libdrm  fontconfig"
# TERMUX_PKG_DEPENDS="libdrm, fontconfig"

termux_step_post_get_source() {
	local _host_builder_dir="${TERMUX_SCRIPTDIR}/x11-packages/carbonyl-host-tools"

	# Move chromium source
	mv chromium-$_CHROMIUM_VERSION chromium/src

	# Apply diffs
	for f in $(find "$_host_builder_dir/" -maxdepth 1 -type f -name *.diff | sort); do
		echo "Applying patch: $(basename $f)"
		patch -p1 < "$f"
	done

	# Apply patches related to chromium
	pushd chromium/src
		for f in $(find "$_host_builder_dir/patches" -maxdepth 1 -type f -name *.patch | sort); do
			echo "Applying patch: $(basename $f)"
			patch -p1 < "$f"
		done
	popd

	# Apply patches related to carbonyl
	pushd chromium/src
	for f in $(find "$TERMUX_PKG_SRCDIR/chromium/patches/chromium/" -maxdepth 1 -type f -name *.patch | sort); do
		echo "Applying patch: $(basename $f)"
		patch --silent -p1 < "$f"
	done
	popd

	pushd chromium/src/third_party/skia
	for f in $(find "$TERMUX_PKG_SRCDIR/chromium/patches/skia/" -maxdepth 1 -type f -name *.diff | sort); do
		echo "Applying patch: $(basename $f)"
		patch --silent -p1 < "$f"
	done
	popd

	pushd chromium/src/third_party/webrtc
	for f in $(find "$TERMUX_PKG_SRCDIR/chromium/patches/webrtc/" -maxdepth 1 -type f -name *.diff | sort); do
		echo "Applying patch: $(basename $f)"
		patch --silent -p1 < "$f"
	done
	popd

	for f in $(find "$_host_builder_dir/" -maxdepth 1 -type f -name *.patch | sort); do
		echo "Applying patch: $(basename $f)"
		patch --silent -p1 < "$f"
	done
}

termux_step_configure() {
	cd $TERMUX_PKG_SRCDIR/chromium/src
	termux_setup_ninja
	termux_setup_gn
	termux_setup_nodejs

	# Remove termux's dummy pkg-config
	local _target_pkg_config=$(command -v pkg-config)
	local _host_pkg_config="$(cat $_target_pkg_config | grep exec | awk '{print $2}')"
	rm -rf $TERMUX_PKG_TMPDIR/host-pkg-config-bin
	mkdir -p $TERMUX_PKG_TMPDIR/host-pkg-config-bin
	ln -s $_host_pkg_config $TERMUX_PKG_TMPDIR/host-pkg-config-bin/pkg-config
	export PATH="$TERMUX_PKG_TMPDIR/host-pkg-config-bin:$PATH"

	# Install amd64 rootfs if necessary
	build/linux/sysroot_scripts/install-sysroot.py --arch=amd64
	local _amd64_sysroot_path="$(pwd)/build/linux/$(ls build/linux | grep 'amd64-sysroot')"

	# Link to system tools required by the build
	mkdir -p third_party/node/linux/node-linux-x64/bin
	ln -sf $(command -v node) third_party/node/linux/node-linux-x64/bin/
	ln -sf $(command -v java) third_party/jdk/current/bin/

	# Dummy librt.so
	# Why not dummy a librt.a? Some of the binaries reference symbols only exists in Android
	# for some reason, such as the `chrome_crashpad_handler`, which needs to link with
	# libprotobuf_lite.a, but it is hard to remove the usage of `android/log.h` in protobuf.
	echo "INPUT(-llog -liconv -landroid-shmem)" > "$TERMUX_PREFIX/lib/librt.so"

	# Dummy libpthread.a and libresolv.a
	echo '!<arch>' > "$TERMUX_PREFIX/lib/libpthread.a"
	echo '!<arch>' > "$TERMUX_PREFIX/lib/libresolv.a"

	# Symlink libffi.a to libffi_pic.a
	ln -sfr $TERMUX_PREFIX/lib/libffi.a $TERMUX_PREFIX/lib/libffi_pic.a

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
	# This is needed to build cups
	cp -Rf $TERMUX_PREFIX/bin/cups-config usr/bin/
	chmod +x usr/bin/cups-config
	popd

	# Construct args
	local _clang_base_path="/usr/lib/llvm-18"
	local _host_cc="$_clang_base_path/bin/clang"
	local _host_cxx="$_clang_base_path/bin/clang++"
	local _host_toolchain="$TERMUX_PKG_CACHEDIR/custom-toolchain:host"
	local _target_cpu _target_sysroot="$TERMUX_PKG_TMPDIR/sysroot"
	local _v8_toolchain_name _v8_current_cpu _v8_sysroot_path
	if [ "$TERMUX_ARCH" = "aarch64" ]; then
		_target_cpu="arm64"
		_v8_current_cpu="arm64"
		_v8_sysroot_path="$_amd64_sysroot_path"
		_v8_toolchain_name="host"
	elif [ "$TERMUX_ARCH" = "arm" ]; then
		# Install i386 rootfs if necessary
		build/linux/sysroot_scripts/install-sysroot.py --arch=i386
		_target_cpu="arm"
		_v8_current_cpu="x86"
		_v8_sysroot_path="$_i386_sysroot_path"
		_v8_toolchain_name="clang_x86_v8_arm"
	elif [ "$TERMUX_ARCH" = "x86_64" ]; then
		_target_cpu="x64"
		_v8_current_cpu="x64"
		_v8_sysroot_path="$_amd64_sysroot_path"
		_v8_toolchain_name="host"
	fi

	local _common_args_file=$TERMUX_PKG_TMPDIR/common-args-file
	rm -f $_common_args_file
	touch $_common_args_file

	echo "
import(\"//carbonyl/src/browser/args.gn\")
# Do not build with symbols
is_debug = false
is_component_build = false
symbol_level = 0
# Use our custom toolchain
use_sysroot = false
target_cpu = \"$_target_cpu\"
target_rpath = \"$TERMUX_PREFIX/lib\"
target_sysroot = \"$_target_sysroot\"
clang_base_path = \"$_clang_base_path\"
custom_toolchain = \"//build/toolchain/linux/unbundle:default\"
host_toolchain = \"$TERMUX_PKG_CACHEDIR/custom-toolchain:host\"
v8_snapshot_toolchain = \"$TERMUX_PKG_CACHEDIR/custom-toolchain:$_v8_toolchain_name\"
clang_use_chrome_plugins = false
dcheck_always_on = false
chrome_pgo_phase = 0
treat_warnings_as_errors = false
# Use system libraries as little as possible
use_bundled_fontconfig = false
use_system_freetype = true
use_system_libdrm = true
use_custom_libcxx = false
use_allocator_shim = false
use_partition_alloc_as_malloc = false
enable_backup_ref_ptr_support = false
enable_mte_checked_ptr_support = false
use_nss_certs = true
use_udev = false
use_gnome_keyring = false
use_alsa = false
use_libpci = false
use_pulseaudio = false
use_ozone = true
use_qt = false
ozone_auto_platforms = false
ozone_platform = \"headless\"
ozone_platform_x11 = false
ozone_platform_wayland = false
ozone_platform_headless = true
angle_enable_vulkan = true
angle_enable_swiftshader = true
rtc_use_pipewire = false
use_vaapi_x11 = false
# See comments on Chromium package
enable_nacl = false
use_thin_lto=false
# Enable jumbo build (unified build)
use_jumbo_build = true
" >> $_common_args_file

	if [ "$TERMUX_ARCH" = "arm" ]; then
		echo "arm_arch = \"armv7-a\"" >> $_common_args_file
		echo "arm_float_abi = \"softfp\"" >> $_common_args_file
	fi

	# Use custom toolchain
	rm -rf $TERMUX_PKG_CACHEDIR/custom-toolchain
	mkdir -p $TERMUX_PKG_CACHEDIR/custom-toolchain
	cp -f $TERMUX_PKG_BUILDER_DIR/toolchain-template/host-toolchain.gn.in $TERMUX_PKG_CACHEDIR/custom-toolchain/BUILD.gn
	sed -i "s|@HOST_CC@|$_host_cc|g
			s|@HOST_CXX@|$_host_cxx|g
			s|@HOST_LD@|$_host_cxx|g
			s|@HOST_AR@|$(command -v llvm-ar)|g
			s|@HOST_NM@|$(command -v llvm-nm)|g
			s|@HOST_IS_CLANG@|true|g
			s|@HOST_USE_GOLD@|false|g
			s|@HOST_SYSROOT@|$_amd64_sysroot_path|g
			s|@V8_CURRENT_CPU@|$_target_cpu|g
			" $TERMUX_PKG_CACHEDIR/custom-toolchain/BUILD.gn
	if [ "$_v8_toolchain_name" != "host" ]; then
		cat $TERMUX_PKG_BUILDER_DIR/toolchain-template/v8-toolchain.gn.in >> $TERMUX_PKG_CACHEDIR/custom-toolchain/BUILD.gn
		sed -i "s|@V8_CC@|$_host_cc|g
				s|@V8_CXX@|$_host_cxx|g
				s|@V8_LD@|$_host_cxx|g
				s|@V8_AR@|$(command -v llvm-ar)|g
				s|@V8_NM@|$(command -v llvm-nm)|g
				s|@V8_TOOLCHAIN_NAME@|$_v8_toolchain_name|g
				s|@V8_CURRENT_CPU@|$_v8_current_cpu|g
				s|@V8_V8_CURRENT_CPU@|$_target_cpu|g
				s|@V8_IS_CLANG@|true|g
				s|@V8_USE_GOLD@|false|g
				s|@V8_SYSROOT@|$_v8_sysroot_path|g
				" $TERMUX_PKG_CACHEDIR/custom-toolchain/BUILD.gn
	fi

	cd $TERMUX_PKG_SRCDIR/chromium/src
	mkdir -p $TERMUX_PKG_BUILDDIR/out/Release
	cat $_common_args_file > $TERMUX_PKG_BUILDDIR/out/Release/args.gn
	gn gen $TERMUX_PKG_BUILDDIR/out/Release --export-compile-commands

	export cr_v8_toolchain="$_v8_toolchain_name"
}

termux_step_make() {
	cd $TERMUX_PKG_SRCDIR
	# Build libcarbonyl
	(termux_setup_rust
	cargo build --jobs $TERMUX_PKG_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release)

	cd $TERMUX_PKG_BUILDDIR
	# Build v8 snapshot and tools
	time ninja -C out/Release \
					v8_context_snapshot \
					run_mksnapshot_default \
					run_torque \
					generate_bytecode_builtins_list \
					v8:run_gen-regexp-special-case

	# Build host tools
	time ninja -C out/Release \
					generate_top_domain_list_variables_file \
					generate_chrome_colors_info \
					character_data \
					gen_root_store_inc \
					generate_transport_security_state \
					generate_top_domains_trie

	# Build swiftshader
	time ninja -C out/Release \
						third_party/swiftshader/src/Vulkan:icd_file \
						third_party/swiftshader/src/Vulkan:swiftshader_libvulkan

	# Build headless shell
	time ninja -C $TERMUX_PKG_BUILDDIR/out/Release headless:headless_shell
}

termux_step_make_install() {
	cd $TERMUX_PKG_BUILDDIR
	mkdir -p $TERMUX_PREFIX/lib/$TERMUX_PKG_NAME

	# Install the runtime library
	termux_setup_rust
	cp $TERMUX_PKG_SRCDIR/build/$CARGO_TARGET_NAME/release/*.so $TERMUX_PREFIX/lib/$TERMUX_PKG_NAME/

	# Install chromium-related files
	local normal_files=(
		# Binary files
		headless_shell
		chrome_crashpad_handler

		# Resource files
		headless_lib_data.pak
		headless_lib_strings.pak

		# V8 Snapshot data
		v8_context_snapshot.bin

		# ICU Data
		icudtl.dat

		# Angle
		libEGL.so
		libGLESv2.so

		# Vulkan
		libvulkan.so.1
		libvk_swiftshader.so
		vk_swiftshader_icd.json
	)

	cp "${normal_files[@]/#/out/Release/}" "$TERMUX_PREFIX/lib/$TERMUX_PKG_NAME/"

	cp -Rf out/Release/angledata $TERMUX_PREFIX/lib/$TERMUX_PKG_NAME/

	chmod +x $TERMUX_PREFIX/lib/$TERMUX_PKG_NAME/headless_shell

	# Install as the default binary
	ln -sfr $TERMUX_PREFIX/lib/$TERMUX_PKG_NAME/headless_shell $TERMUX_PREFIX/bin/carbonyl
}

termux_step_post_make_install() {
	# Remove the dummy files
	rm $TERMUX_PREFIX/lib/lib{{pthread,resolv,ffi_pic}.a,rt.so}
}
