TERMUX_PKG_HOMEPAGE="https://github.com/mono/SkiaSharp"
TERMUX_PKG_DESCRIPTION="SkiaSharp is a cross-platform 2D graphics API for .NET platforms"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
_COMMIT=c16e913577083761d847146db7a04b8d3b3bf755
_COMMIT_DATE=20241024
TERMUX_PKG_VERSION="3.116.1.${_COMMIT_DATE}"
TERMUX_PKG_SRCURL="https://github.com/mono/skia/archive/${_COMMIT}.tar.gz"
TERMUX_PKG_SHA256=3fd17a42cca9a7dbde68ab016969b70ab7dd4833403ac1a192e1aa51aed4617b
TERMUX_PKG_DEPENDS="libexpat, libglvnd, libpng, libwebp, freetype, zlib, libjpeg-turbo"
TERMUX_PKG_BUILD_DEPENDS="libc++"
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

	local LIBS_CFLAGS="$(pkg-config --cflags freetype2 libpng libwebp expat opengl egl)"
	local LIBS_LDFLAGS="$(pkg-config --libs freetype2 libpng libwebp expat opengl egl)"
	local _flag _GN_CFLAGS _GN_LDFLAGS _GN_CPPFLAGS _GN_LIBS
	for _flag in CFLAGS LDFLAGS CPPFLAGS LIBS_CFLAGS LIBS_LDFLAGS; do
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
	skia_enable_gpu=true \
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
# https://github.com/mono/SkiaSharp/blob/release/3.116.1/native/android/build.cake
# https://gn.googlesource.com/gn/+/main/docs/reference.md
