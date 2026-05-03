TERMUX_PKG_HOMEPAGE=https://elinux.org/Android_aapt
TERMUX_PKG_DESCRIPTION="Android Asset Packaging Tool"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=35.0.2
TERMUX_PKG_SRCURL=git+https://github.com/ReVanced/aapt2
TERMUX_PKG_GIT_BRANCH="v1.0.0"
TERMUX_PKG_SHA256=de40fbcfd512db63f8769d0cf0f1710a5f6e47784bb41171b97166e9a6809ced
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_DEPENDS="fmt, libc++, libexpat, libpng, libzopfli, zlib"
TERMUX_PKG_BUILD_DEPENDS="googletest, libtbb"

termux_step_post_get_source() {
	git fetch --unshallow
	git submodule update --init --recursive --depth=1
	git clean -ffxd
	mkdir -p "submodules/incremental_delivery/sysprop/include/"
	cp "misc/IncrementalProperties.sysprop.h" "submodules/incremental_delivery/sysprop/include/"
	cp "misc/IncrementalProperties.sysprop.cpp" "submodules/incremental_delivery/sysprop/"
	cp "misc/platform_tools_version.h" "submodules/soong/cc/libbuildversion/include"
	# As our sources are in submodules and not in frameworks/base/tools/aapt2 we need to change the inclusions
	configPattern="s#frameworks/base/tools/aapt2/Configuration.proto#Configuration.proto#g"
	resourcesPattern="s#frameworks/base/tools/aapt2/Resources.proto#Resources.proto#g"
	sed -i "$configPattern" "submodules/base/tools/aapt2/Resources.proto"
	sed -i "$configPattern" "submodules/base/tools/aapt2/ResourcesInternal.proto"
	sed -i "$resourcesPattern" "submodules/base/tools/aapt2/ApkInfo.proto"
	sed -i "$resourcesPattern" "submodules/base/tools/aapt2/ResourcesInternal.proto"
}

termux_step_pre_configure() {
	ln -sf "submodules/googletest" "submodules/boringssl/src/third_party/googletest"
}

termux_step_configure()	{
	ANDROID_NDK="${TERMUX_PKG_SRCDIR}/android-ndk-r27c"
	NDK_TOOLCHAIN="$ANDROID_NDK/build/cmake/android.toolchain.cmake"
}

termux_step_make()	{
	export CC="$ANDROID_NDK/toolchains/llvm/prebuilt/linux-x86_64/bin/clang"
	export CXX="$ANDROID_NDK/toolchains/llvm/prebuilt/linux-x86_64/bin/clang++"
	CMAKE_PROC="${TERMUX_ARCH}"
	case "${CMAKE_PROC}" in
		aarch64) CMAKE_PROC="arm64-v8a" ;;
		arm) CMAKE_PROC="armeabi-v7a" ;;
		i686) CMAKE_PROC="x86" ;;
		x86_64) CMAKE_PROC="x86_64" ;;
	esac
	wget https://dl.google.com/android/repository/android-ndk-r27c-linux.zip -O ndk.zip
	unzip -q ndk.zip
	mkdir protoc
	local _PROTOBUF_VERSION="21.12"
	local _PROTOBUF_ZIP="protoc-21.12-linux-x86_64.zip"
	local _PROTOBUF_SHA256=3a4c1e5f2516c639d3079b1586e703fc7bcfa2136d58bda24d1d54f949c315e8
	local _PROTOBUF_FOLDER

	if [ "${TERMUX_PACKAGES_OFFLINE-false}" = "true" ]; then
		_PROTOBUF_FOLDER="${TERMUX_SCRIPTDIR}/build-tools/protobuf-${_PROTOBUF_VERSION}"
	else
		_PROTOBUF_FOLDER="${TERMUX_COMMON_CACHEDIR}/protobuf-${_PROTOBUF_VERSION}"
	fi

	if [ "$TERMUX_ON_DEVICE_BUILD" = "false" ]; then
		if [ ! -d "$_PROTOBUF_FOLDER" ]; then
			termux_download \
				"https://github.com/protocolbuffers/protobuf/releases/download/v$_PROTOBUF_VERSION/$_PROTOBUF_ZIP" \
				"$TERMUX_PKG_TMPDIR/$_PROTOBUF_ZIP" \
				"$_PROTOBUF_SHA256"

			rm -Rf "$TERMUX_PKG_TMPDIR/protoc-$_PROTOBUF_VERSION-linux-x86_64"
			unzip "$TERMUX_PKG_TMPDIR/$_PROTOBUF_ZIP" -d "$TERMUX_PKG_TMPDIR/protobuf-$_PROTOBUF_VERSION"
			mv "$TERMUX_PKG_TMPDIR/protobuf-$_PROTOBUF_VERSION" \
				"$_PROTOBUF_FOLDER"
		fi

		export PATH="$_PROTOBUF_FOLDER/bin/:$PATH"
	fi
	protoc --version
	termux_setup_cmake
	termux_setup_ninja
	# Run make for the target architecture.
	cmake -GNinja \
		-B "build" \
		-DANDROID_NDK="$ANDROID_NDK" \
		-DCMAKE_TOOLCHAIN_FILE="$NDK_TOOLCHAIN" \
		-DANDROID_PLATFORM="android-30" \
		-DCMAKE_ANDROID_ARCH_ABI="$CMAKE_PROC" \
		-DANDROID_ABI="$CMAKE_PROC" \
		-DCMAKE_SYSTEM_NAME=Android \
		-DANDROID_ARM_NEON=ON \
		-DCMAKE_BUILD_TYPE=Release \
		-DPNG_SHARED=OFF \
		-DZLIB_USE_STATIC_LIBS=ON \
		-DEXPAT_BUILD_TOOLS=OFF \
		-DEXPAT_BUILD_EXAMPLES=OFF \
		-DEXPAT_BUILD_TESTS=OFF \
		-DEXPAT_SHARED_LIBS=OFF \
		-DCMAKE_CXX_STANDARD=17 \
		-DCMAKE_CXX_STANDARD_REQUIRED=ON \
		-DCMAKE_CXX_FLAGS="$CXXFLAGS -DFMT_ENFORCE_COMPILE_STRING=0" \
		-DCMAKE_CXX_EXTENSIONS=OFF \
		-DEXPAT_BUILD_TOOLS=OFF
	# Build the binary
	ninja -C build aapt2
}

termux_step_make_install()	{
	install -Dm755 "${TERMUX_PKG_SRCDIR}/build/bin/aapt2-${CMAKE_PROC}" "${TERMUX_PREFIX}/bin/aapt2"
}
