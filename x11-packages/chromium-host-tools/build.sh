TERMUX_PKG_HOMEPAGE=https://www.chromium.org/Home
TERMUX_PKG_DESCRIPTION="Chromium web browser (Host tools)"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@licy183"
TERMUX_PKG_VERSION=135.0.7049.84
TERMUX_PKG_SRCURL=https://commondatastorage.googleapis.com/chromium-browser-official/chromium-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=43fafda47b177c4aa89ab2849bfb8e9bf035be5281f9bb0e0cae41eabd53832e
TERMUX_PKG_DEPENDS="atk, cups, dbus, fontconfig, gtk3, krb5, libc++, libdrm, libevdev, libxkbcommon, libminizip, libnss, libx11, mesa, openssl, pango, pulseaudio, zlib"
TERMUX_PKG_BUILD_DEPENDS="libffi-static"
# TODO: Split chromium-common and chromium-headless
# TERMUX_PKG_DEPENDS+=", chromium-common"
# TERMUX_PKG_SUGGESTS="chromium-headless, chromium-driver"
# Chromium doesn't support i686 on Linux.
TERMUX_PKG_EXCLUDED_ARCHES="i686"
TERMUX_PKG_NO_STRIP=true
TERMUX_PKG_NO_ELF_CLEANER=true

SYSTEM_LIBRARIES="    fontconfig"
# TERMUX_PKG_DEPENDS="fontconfig"

termux_step_post_get_source() {
	# Apply patches related to chromium
	local f
	for f in $(find "$TERMUX_PKG_BUILDER_DIR/cr-patches" -maxdepth 1 -type f -name *.patch | sort); do
		echo "Applying patch: $(basename $f)"
		patch -p1 < "$f"
	done

	# Apply patches for jumbo build
	local f
	for f in $(find "$TERMUX_PKG_BUILDER_DIR/jumbo-patches" -maxdepth 1 -type f -name *.patch | sort); do
		echo "Applying patch: $(basename $f)"
		patch -p1 < "$f"
	done

	# Use some system libs
	python3 build/linux/unbundle/replace_gn_files.py --system-libraries \
		$SYSTEM_LIBRARIES

	# Remove the source file to keep more space
	rm -f "$TERMUX_PKG_CACHEDIR/chromium-$TERMUX_PKG_VERSION.tar.xz"
}

termux_step_pre_configure() {
	# Certain packages are not safe to build on device because their
	# build.sh script deletes specific files in $TERMUX_PREFIX.
	if $TERMUX_ON_DEVICE_BUILD; then
		termux_error_exit "Package '$TERMUX_PKG_NAME' is not safe for on-device builds."
	fi
}

termux_step_configure() {
	cd $TERMUX_PKG_SRCDIR
	termux_setup_ninja

	# Fetch depot_tools
	export DEPOT_TOOLS_UPDATE=0
	if [ ! -f "$TERMUX_PKG_CACHEDIR/.depot_tools-fetched" ];then
		git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git $TERMUX_PKG_CACHEDIR/depot_tools
		touch "$TERMUX_PKG_CACHEDIR/.depot_tools-fetched"
	fi
	export PATH="$TERMUX_PKG_CACHEDIR/depot_tools:$PATH"

	# Remove termux's dummy pkg-config
	local _target_pkg_config=$(command -v pkg-config)
	local _host_pkg_config="$(cat $_target_pkg_config | grep exec | awk '{print $2}')"
	rm -rf $TERMUX_PKG_CACHEDIR/host-pkg-config-bin
	mkdir -p $TERMUX_PKG_CACHEDIR/host-pkg-config-bin
	ln -s $_host_pkg_config $TERMUX_PKG_CACHEDIR/host-pkg-config-bin/pkg-config
	export PATH="$TERMUX_PKG_CACHEDIR/host-pkg-config-bin:$PATH"

	# Install amd64 rootfs and deps
	build/linux/sysroot_scripts/install-sysroot.py --arch=amd64
	local _amd64_sysroot_path="$(pwd)/build/linux/$(ls build/linux | grep 'amd64-sysroot')"

	# Setup rust toolchain and clang toolchain
	./tools/rust/update_rust.py
	./tools/clang/scripts/update.py

	# Link to system tools required by the build
	ln -sf $(command -v java) third_party/jdk/current/bin/

	# Install nodejs
	if [ ! -f "third_party/node/linux/node-linux-x64/bin/node" ]; then
		./third_party/node/update_node_binaries
	fi

	local CARGO_TARGET_NAME="${TERMUX_ARCH}-linux-android"
	if [[ "${TERMUX_ARCH}" == "arm" ]]; then
		CARGO_TARGET_NAME="armv7-linux-androideabi"
	fi

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
	if [ ! -d "$TERMUX_PKG_CACHEDIR/sysroot-$TERMUX_ARCH" ]; then
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
		# This is needed to build crashpad
		rm -rf $TERMUX_PREFIX/include/spawn.h
		# This is needed to build cups
		cp -Rf $TERMUX_PREFIX/bin/cups-config usr/bin/
		chmod +x usr/bin/cups-config
		popd
		mv $TERMUX_PKG_TMPDIR/sysroot $TERMUX_PKG_CACHEDIR/sysroot-$TERMUX_ARCH
	fi

	# Construct args
	local _clang_base_path="$PWD/third_party/llvm-build/Release+Asserts"
	local _host_cc="$_clang_base_path/bin/clang"
	local _host_cxx="$_clang_base_path/bin/clang++"
	local _host_clang_version=$($_host_cc --version | grep -m1 version | sed -E 's|.*\bclang version ([0-9]+).*|\1|')
	local _target_clang_base_path="$TERMUX_STANDALONE_TOOLCHAIN"
	local _target_cc="$_target_clang_base_path/bin/clang"
	local _target_clang_version=$($_target_cc --version | grep -m1 version | sed -E 's|.*\bclang version ([0-9]+).*|\1|')
	local _target_cpu _target_sysroot="$TERMUX_PKG_CACHEDIR/sysroot-$TERMUX_ARCH"
	local _v8_toolchain_name _v8_current_cpu _v8_sysroot_path
	if [ "$TERMUX_ARCH" = "aarch64" ]; then
		_target_cpu="arm64"
		_v8_current_cpu="arm64"
		_v8_sysroot_path="$_amd64_sysroot_path"
		_v8_toolchain_name="host"
	elif [ "$TERMUX_ARCH" = "arm" ]; then
		# Install i386 rootfs and deps
		build/linux/sysroot_scripts/install-sysroot.py --arch=i386
		local _i386_sysroot_path="$(pwd)/build/linux/$(ls build/linux | grep 'i386-sysroot')"
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
# Do official build to decrease file size
is_official_build = true
is_debug = false
symbol_level = 0
# Use our custom toolchain
clang_version = \"$_host_clang_version\"
use_sysroot = false
target_cpu = \"$_target_cpu\"
target_rpath = \"$TERMUX_PREFIX/lib\"
target_sysroot = \"$_target_sysroot\"
custom_toolchain = \"//build/toolchain/linux/unbundle:default\"
custom_toolchain_clang_base_path = \"$_target_clang_base_path\"
custom_toolchain_clang_version = \"$_target_clang_version\"
host_toolchain = \"$TERMUX_PKG_CACHEDIR/custom-toolchain:host\"
v8_snapshot_toolchain = \"$TERMUX_PKG_CACHEDIR/custom-toolchain:$_v8_toolchain_name\"
clang_use_chrome_plugins = false
dcheck_always_on = false
chrome_pgo_phase = 0
treat_warnings_as_errors = false
# Use system libraries as little as possible
use_system_freetype = false
# use_system_libdrm = true
use_system_libffi = false
use_custom_libcxx = false
use_custom_libcxx_for_host = true
use_allocator_shim = false
use_partition_alloc_as_malloc = false
enable_backup_ref_ptr_slow_checks = false
enable_dangling_raw_ptr_checks = false
enable_dangling_raw_ptr_feature_flag = false
backup_ref_ptr_extra_oob_checks = false
enable_backup_ref_ptr_support = false
enable_pointer_compression_support = false
use_nss_certs = true
use_udev = false
use_ozone = true
ozone_auto_platforms = false
ozone_platform = \"x11\"
ozone_platform_x11 = true
# TODO: Enable wayland
ozone_platform_wayland = false
ozone_platform_headless = true
angle_enable_vulkan = true
angle_enable_swiftshader = true
angle_enable_abseil = false
# Use Chrome-branded ffmpeg for more codecs
is_component_ffmpeg = true
ffmpeg_branding = \"Chrome\"
proprietary_codecs = true
use_qt5 = false
use_qt6 = false
use_libpci = false
use_alsa = false
use_pulseaudio = true
rtc_use_pipewire = false
use_vaapi = false
# See comments below
enable_nacl = false
# Host compiler (clang-13) doesn't support LTO well
is_cfi = false
use_cfi_icall = false
use_thin_lto = false
# Enable rust
custom_target_rust_abi_target = \"$CARGO_TARGET_NAME\"
llvm_android_mainline = true
exclude_unwind_tables = false
# Enable jumbo build (unified build)
use_jumbo_build = true
# Compile pdfium as a static library
pdf_is_complete_lib = true
" > $_common_args_file

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
				s|@V8_SYSROOT@|$_v8_sysroot_path|g
				" $TERMUX_PKG_CACHEDIR/custom-toolchain/BUILD.gn
	fi

	# Generate ninja files
	mkdir -p $TERMUX_PKG_BUILDDIR/out/Release
	cat $_common_args_file > $TERMUX_PKG_BUILDDIR/out/Release/args.gn
	gn gen $TERMUX_PKG_BUILDDIR/out/Release

	export cr_v8_toolchain="$_v8_toolchain_name"
}

termux_step_make() {
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

	# Build pdfium
	time ninja -C out/Release \
						third_party/pdfium \
						third_party/pdfium:pdfium_public_headers
}

termux_step_make_install() {
	cd $TERMUX_PKG_BUILDDIR
	mkdir -p $TERMUX_PREFIX/opt/$TERMUX_PKG_NAME

	local v8_tools=(
		mksnapshot                       # run_mksnapshot_default
		torque                           # torque
		bytecode_builtins_list_generator # generate_bytecode_builtins_list
		gen-regexp-special-case          # v8:run_gen-regexp-special-case
	)
	mkdir -p "$TERMUX_PREFIX/opt/$TERMUX_PKG_NAME/$cr_v8_toolchain/"
	cp "${v8_tools[@]/#/out/Release/$cr_v8_toolchain/}" "$TERMUX_PREFIX/opt/$TERMUX_PKG_NAME/$cr_v8_toolchain/"

	local host_tools=(
		make_top_domain_list_variables     # generate_top_domain_list_variables_file
		generate_colors_info               # generate_chrome_colors_info
		character_data_generator           # character_data
		root_store_tool                    # gen_root_store_inc
		transport_security_state_generator # generate_transport_security_state
		top_domain_generator               # generate_top_domains_trie
		icudtl.dat                         # icu data
	)
	mkdir -p "$TERMUX_PREFIX/opt/$TERMUX_PKG_NAME/host/"
	cp "${host_tools[@]/#/out/Release/host/}" "$TERMUX_PREFIX/opt/$TERMUX_PKG_NAME/host/"

	local normal_files=(
		# v8 snapshot data
		snapshot_blob.bin
		v8_context_snapshot.bin

		# swiftshader
		libvk_swiftshader.so
		vk_swiftshader_icd.json
	)
	cp "${normal_files[@]/#/out/Release/}" "$TERMUX_PREFIX/opt/$TERMUX_PKG_NAME/"

	mkdir -p "$TERMUX_PREFIX/opt/$TERMUX_PKG_NAME/obj/third_party/pdfium/"
	cp "out/Release/obj/third_party/pdfium/libpdfium.a" "$TERMUX_PREFIX/opt/$TERMUX_PKG_NAME/obj/third_party/pdfium/"
}

termux_step_post_make_install() {
	# Remove the dummy files
	rm $TERMUX_PREFIX/lib/lib{{pthread,resolv,ffi_pic}.a,rt.so}
}
