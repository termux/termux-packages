TERMUX_PKG_HOMEPAGE="https://github.com/mono/SkiaSharp"
TERMUX_PKG_DESCRIPTION="SkiaSharp is a cross-platform 2D graphics API for .NET platforms"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
_COMMIT=v3.119.4
_COMMIT_DATE=20260525
TERMUX_PKG_VERSION="3.119.4.${_COMMIT_DATE}"

# Target the official source release archive for the tag
TERMUX_PKG_SRCURL="https://github.com/mono/SkiaSharp/archive/refs/tags/v3.119.4.tar.gz"
TERMUX_PKG_SHA256=caf91eea422e043007368fc19e09c310eed28dee14f8133292640264b78b0e8c

TERMUX_PKG_DEPENDS="libexpat, libglvnd, libpng, libwebp, freetype, zlib, libjpeg-turbo"
TERMUX_PKG_BUILD_DEPENDS="libc++, gn, python"
TERMUX_PKG_EXCLUDED_ARCHES="arm"

termux_step_make() {
	if [ -f "$TERMUX_PKG_BUILDDIR/libSkiaSharp.so" ] && [ -f "$TERMUX_PKG_BUILDDIR/libHarfBuzzSharp.so" ]; then
		echo "Skipping compilation as build output is already present."
		return
	fi

	termux_setup_gn
	local _target_cpu=""
	case "$TERMUX_ARCH" in
	aarch64) _target_cpu="arm64" ;;
	x86_64) _target_cpu="x64" ;;
	i686) _target_cpu="x86" ;;
	*) termux_error_exit "Unsupported arch: $TERMUX_ARCH" ;;
	esac

	# Ensure NDK sources are available in the standalone toolchain directory
	# since Skia's third_party libraries (zlib, libwebp, cpu-features) reference them.
	ln -sf "$NDK/sources" "$TERMUX_STANDALONE_TOOLCHAIN/sources"

	if [ "$TERMUX_ON_DEVICE_BUILD" = "true" ]; then
		# Setup a mock NDK compiler wrapper layout inside the standalone toolchain directory.
		# This is required on-device because Skia unconditionally expects NDK compiler paths
		# for target_os="android" builds (resolving to toolchains/llvm/prebuilt/linux-x86_64/bin).
		local _toolchain_bin="$TERMUX_STANDALONE_TOOLCHAIN/toolchains/llvm/prebuilt/linux-x86_64/bin"
		local _sysroot="$TERMUX_STANDALONE_TOOLCHAIN/toolchains/llvm/prebuilt/linux-x86_64/sysroot"
		mkdir -p "$_toolchain_bin" "$_sysroot"

		local _ndk_target=""
		case "$TERMUX_ARCH" in
		aarch64) _ndk_target="aarch64-linux-android" ;;
		x86_64) _ndk_target="x86_64-linux-android" ;;
		i686) _ndk_target="i686-linux-android" ;;
		esac

		rm -rf "$_sysroot/usr"
		ln -sf "$TERMUX_PREFIX" "$_sysroot/usr"
		ln -sf "$(command -v clang)" "$_toolchain_bin/${_ndk_target}${TERMUX_PKG_API_LEVEL}-clang"
		ln -sf "$(command -v clang++)" "$_toolchain_bin/${_ndk_target}${TERMUX_PKG_API_LEVEL}-clang++"
		ln -sf "$(command -v llvm-ar)" "$_toolchain_bin/llvm-ar"
	fi

	pushd "$TERMUX_PKG_SRCDIR"

	# Initialize a fresh git workspace out of the extracted tarball
	# to allow submodule checking to work seamlessly
	rm -rf .git
	git init
	git config user.email "termux@localhost"
	git config user.name "termux"
	git remote add origin https://github.com/mono/SkiaSharp.git
	git fetch --depth 1 origin "$_COMMIT"
	git reset --hard FETCH_HEAD

	# Now submodules can safely be cloned relative to this commit context
	git submodule update --init --recursive

	# Move inside the submodule source directory where tools reside
	cd externals/skia

	# Hot-fix: Patch fetch-gn to prevent KeyError: 'android' on native Termux builds
	sed -i "s/sys.platform/'linux'/g" bin/fetch-gn

	python3 tools/git-sync-deps

	# Apply null-safety fixes to sk_codec.cpp to prevent native SIGSEGV crashes on corrupt media files
	cp "$TERMUX_PKG_BUILDER_DIR/sk_codec.cpp.nullsafe" src/c/sk_codec.cpp
	cp "$TERMUX_PKG_BUILDER_DIR/SkJpegCodec.cpp.patched" src/codec/SkJpegCodec.cpp

	local LIBS_CFLAGS="$(pkg-config --cflags freetype2 libpng libwebp expat opengl egl)"
	local LIBS_LDFLAGS="$(pkg-config --libs freetype2 libpng libwebp expat opengl egl)"
	local _flag _GN_CFLAGS _GN_LDFLAGS _GN_CPPFLAGS _GN_LIBS
	for _flag in CFLAGS LDFLAGS CPPFLAGS LIBS_CFLAGS LIBS_LDFLAGS; do
		declare _GN_"${_flag}"="$(eval printf '%s' "\"\$${_flag}\"" | awk '{for (i=1;i<NF;i++) { printf "\"%s\", ",$i }; printf "\"%s\"",$i}')"
	done

	local _args_pre=""
	local _args=""

	# Configuration Block A: SkiaSharp Native Binary Compilation
	_args_pre="target_os='android' \
	target_cpu='${_target_cpu}' \
	skia_use_icu=false \
	skia_use_harfbuzz=false \
	skia_use_piex=true \
	skia_use_sfntly=false \
	skia_enable_ganesh=true \
	skia_enable_tools=false \
	skia_use_dng_sdk=false \
	skia_use_gl=true \
	skia_use_vulkan=false \
	skia_use_system_expat=true \
	skia_use_system_libjpeg_turbo=true \
	skia_use_system_freetype2=true \
	skia_use_system_libpng=true \
	skia_use_system_libwebp=true \
	skia_use_system_zlib=true \
	skia_enable_skottie=true \
	skia_use_wuffs=false \
	third_party_isystem=false \
	cc='$CC' \
	cxx='$CXX' \
	ar='$AR' \
	ndk='${TERMUX_STANDALONE_TOOLCHAIN}' \
	ndk_api=${TERMUX_PKG_API_LEVEL} \
	extra_asmflags=[] \
	extra_cflags=[ '-DSKIA_C_DLL', '-DHAVE_SYSCALL_GETRANDOM', '-DXML_DEV_URANDOM' ] \
	extra_ldflags=[ '-static-libstdc++', '-Wl,--no-undefined', '-Wl,-z,max-page-size=16384' ] \
	is_official_build=true \
	extra_asmflags+=[ '-no-integrated-as', '-I${TERMUX_PREFIX}/include' ] \
	extra_cflags+=[ '-Wno-macro-redefined', ${_GN_CPPFLAGS}, ${_GN_CFLAGS}, ${_GN_LIBS_CFLAGS} ] \
	extra_ldflags+=[ ${_GN_LDFLAGS}, ${_GN_LIBS_LDFLAGS} ]"
	_args="$(printf "%s\n" "${_args_pre}" | tr \' \" | tr -d '\t')"

	gn gen 'out' --args="${_args}"
	ninja -C out SkiaSharp

	# Configuration Block B: HarfBuzzSharp Native Binary Compilation
	_args_pre="target_os='android' \
	target_cpu='${_target_cpu}' \
	visibility_hidden=false \
	cc='$CC' \
	cxx='$CXX' \
	ar='$AR' \
	ndk='${TERMUX_STANDALONE_TOOLCHAIN}' \
	ndk_api=${TERMUX_PKG_API_LEVEL} \
	extra_asmflags=[] \
	extra_cflags=[] \
	extra_ldflags=[ '-static-libstdc++', '-Wl,--no-undefined', '-Wl,-z,max-page-size=16384' ] \
	is_official_build=true \
	extra_asmflags+=[ '-no-integrated-as', '-I${TERMUX_PREFIX}/include' ] \
	extra_cflags+=[ '-Wno-macro-redefined', ${_GN_CPPFLAGS}, ${_GN_CFLAGS} ] \
	extra_ldflags+=[ ${_GN_LDFLAGS} ]"
	_args="$(printf "%s\n" "${_args_pre}" | tr \' \" | tr -d '\t')"

	gn gen 'out' --args="${_args}"
	ninja -C out HarfBuzzSharp

	cp out/libSkiaSharp.so out/libHarfBuzzSharp.so "$TERMUX_PKG_BUILDDIR"
	popd
}

termux_step_make_install() {
	install -Dm600 -t "${TERMUX_PREFIX}/lib/libskiasharp3" "${TERMUX_PKG_BUILDDIR}/libSkiaSharp.so"
	install -Dm600 -t "${TERMUX_PREFIX}/lib/libskiasharp3" "${TERMUX_PKG_BUILDDIR}/libHarfBuzzSharp.so"
}

termux_step_post_massage() {
	# Remove any stray files captured from the host system during on-device build
	rm -rf var/
}
