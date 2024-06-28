TERMUX_PKG_HOMEPAGE=https://github.com/fonttools/skia-pathops
TERMUX_PKG_DESCRIPTION="Python bindings for the Skia library's Path Ops"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="Nguyen Khanh @nguynkhn"
TERMUX_PKG_VERSION=0.8.0
_SUFFIX='post1'
TERMUX_PKG_SRCURL=https://github.com/fonttools/skia-pathops/archive/refs/tags/v${TERMUX_PKG_VERSION}.${_SUFFIX}.tar.gz
TERMUX_PKG_SHA256=88bd5872bb96e19108ff7265cae2e1708f5e7f335b39ebfdd023940970e1d54c
TERMUX_PKG_DEPENDS="libc++, python"
TERMUX_PKG_PYTHON_COMMON_DEPS="setuptools, wheel, setuptools_scm, 'Cython>=0.28.4'"
TERMUX_PKG_BUILD_IN_SRC=true

_SKIA_REPO_URL=git+https://skia.googlesource.com/skia.git
_SKIA_REPO_BRANCH=chrome/m113

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ndk=\"${NDK}\"
is_official_build=true
is_debug=false
skia_enable_pdf=false
skia_enable_discrete_gpu=false
skia_enable_skottie=false
skia_enable_skshaper=false
skia_use_dng_sdk=false
skia_use_expat=false
skia_use_freetype=false
skia_use_fontconfig=false
skia_use_fonthost_mac=false
skia_use_harfbuzz=false
skia_use_icu=false
skia_use_libjpeg_turbo_encode=false
skia_use_libjpeg_turbo_decode=false
skia_use_libpng_encode=false
skia_use_libpng_decode=false
skia_use_libwebp_encode=false
skia_use_libwebp_decode=false
skia_use_piex=false
skia_use_sfntly=false
skia_use_xps=false
skia_use_zlib=false
skia_enable_spirv_validation=false
skia_use_libheif=false
skia_use_lua=false
skia_use_wuffs=false
skia_enable_fontmgr_empty=true
skia_enable_gpu=false
skia_use_gl=false
"

termux_step_pre_configure() {
	termux_setup_gn

	local _arch
	case "$TERMUX_ARCH" in
		'aarch64') _arch='arm64';;
		'arm')     _arch='arm';;
		'x86_64')  _arch='x64';;
		'i686')    _arch='x86';;
		*) termux_error_exit "Architecture not supported by build system"
	esac
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+="target_cpu=\"${_arch}\""

	sed -i "s|@SKIA_DIR@|${TERMUX_PKG_SRCDIR}/skia|g" "${TERMUX_PKG_SRCDIR}/setup.py"

	export SETUPTOOLS_SCM_PRETEND_VERSION="${TERMUX_PKG_VERSION}.${_SUFFIX}"
	export BUILD_SKIA_FROM_SOURCE=0
	export SKIA_LIBRARY_DIR=$TERMUX_PKG_SRCDIR/skia/out
	LDFLAGS+=" -llog"
}

termux_step_make() {
	git clone --depth 1 --branch $_SKIA_REPO_BRANCH ${_SKIA_REPO_URL#git+} $TERMUX_PKG_SRCDIR/skia

	cd $TERMUX_PKG_SRCDIR/skia
	git fetch --unshallow

	gn gen out "--args=${TERMUX_PKG_EXTRA_CONFIGURE_ARGS}"
	ninja -C out
}
