TERMUX_PKG_HOMEPAGE="https://github.com/mono/SkiaSharp"
TERMUX_PKG_DESCRIPTION="SkiaSharp is a cross-platform 2D graphics API for .NET platforms"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
_COMMIT=4bed689c9c9eb77a120c6a9d54af6a572c85d1c2
_COMMIT_DATE=20241011
TERMUX_PKG_VERSION="2.88.9.${_COMMIT_DATE}"
TERMUX_PKG_SRCURL="https://github.com/mono/skia/archive/${_COMMIT}.tar.gz"
TERMUX_PKG_SHA256=4dee89bef1406efd0f0c35ef24ec801a8f18ad37d6033d4360c2120eb858da0e
TERMUX_PKG_DEPENDS="libc++, libexpat, libpng, libwebp, freetype, zlib"
TERMUX_PKG_EXCLUDED_ARCHES="arm"

termux_step_make() {
	termux_setup_gn
	local _target_cpu=""
	case "$TERMUX_ARCH" in
		aarch64) _target_cpu="arm64" ;;
#		arm) _target_cpu="arm" ;;
		x86_64) _target_cpu="x64" ;;
		i686) _target_cpu="x86" ;;
		*) termux_error_exit  "Unsupported arch: $TERMUX_ARCH"
	esac

	pushd "$TERMUX_PKG_SRCDIR"
	./tools/git-sync-deps

	# we must use version 62 of libjpeg-turbo
	# https://github.com/libjpeg-turbo/libjpeg-turbo/issues/795#issuecomment-2484148592
	local _flag _GN_CFLAGS _GN_LDFLAGS _GN_CPPFLAGS
	for _flag in CFLAGS LDFLAGS CPPFLAGS; do
		# converts xFLAGS into GN form
		# For example: CFLAGS="-O3 -fno-vectorize"
		# becomes _GN_CFLAGS='"-O3", "-fno-vectorize"'
		declare _GN_"${_flag}"="$(eval printf '%s' "\"\$${_flag}\"" | awk '{for (i=1;i<NF;i++) { printf "\"%s\", ",$i }; printf "\"%s\"",$i}' )"
	done
	local _args_pre=""
	local _args=""
	# note all single quotes get converted into double quotes and all tabs get stripped before being fed into gn
	_args_pre="target_os='android' \
	target_cpu='${_target_cpu}' \
	skia_use_icu=false \
	skia_use_harfbuzz=false \
	skia_use_piex=true \
	skia_use_sfntly=false \
	skia_enable_gpu=false \
	skia_enable_tools=false \
	skia_use_dng_sdk=false \
	skia_use_gl=false \
	skia_use_vulkan=false \
	skia_use_system_expat=true \
	skia_use_system_libjpeg_turbo=false \
	skia_use_system_freetype2=true \
	skia_use_system_libpng=true \
	skia_use_system_libwebp=true \
	skia_use_system_zlib=true \
	skia_enable_skottie=true \
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
	extra_cflags+=[ '-Wno-macro-redefined', ${_GN_CPPFLAGS}, ${_GN_CFLAGS}, $(pkg-config --cflags freetype2 libpng libwebp expat | awk '{for (i=1;i<NF;i++) { printf "\"%s\", ",$i }; printf "\"%s\"",$i}') ] \
	extra_ldflags+=[ ${_GN_LDFLAGS}, $(pkg-config --libs freetype2 libpng libwebp expat | awk '{for (i=1;i<NF;i++) { printf "\"%s\", ",$i }; printf "\"%s\"",$i}') ]"
	_args="$(printf "%s\n" "${_args_pre}" | tr \' \" | tr -d '\t')"

	gn gen 'out' --args="${_args}"
	ninja -C out SkiaSharp

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
	install -Dm600 -t "${TERMUX_PREFIX}/lib" "${TERMUX_PKG_BUILDDIR}/libSkiaSharp.so"
	install -Dm600 -t "${TERMUX_PREFIX}/lib" "${TERMUX_PKG_BUILDDIR}/libHarfBuzzSharp.so"
}
# References
# https://cgit.freebsd.org/ports/tree/graphics/libskiasharp
# https://bugs.freebsd.org/bugzilla/show_bug.cgi?id=282704
# https://github.com/mono/SkiaSharp/blob/release/2.88.9/native/android/build.cake
# https://gn.googlesource.com/gn/+/main/docs/reference.md
