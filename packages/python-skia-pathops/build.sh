TERMUX_PKG_HOMEPAGE=https://github.com/fonttools/skia-pathops
TERMUX_PKG_DESCRIPTION="Python bindings for the Skia library's Path Ops"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="Nguyen Khanh @nguynkhn"
TERMUX_PKG_VERSION=0.9.1
TERMUX_PKG_SRCURL=https://github.com/fonttools/skia-pathops/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=95d3b195147f80a9ae8baaa72c28bed359857d90e1930a8274169c6d05396323
TERMUX_PKG_DEPENDS="libc++, python, python-pip"
TERMUX_PKG_PYTHON_COMMON_BUILD_DEPS="setuptools, wheel, setuptools_scm, 'Cython>=3.2.0'"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

_SKIA_REPO_URL=git+https://github.com/fonttools/skia.git
_SKIA_REPO_BRANCH=chrome/m143-no-deps
_SKIA_REPO_COMMIT=a777ad7f829750a44b8fa9f6df4a2d1154abf1ad
_SKIA_REPO_DIR=${TERMUX_PKG_SRCDIR}/src/cpp/skia-builder/skia

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ndk=\"${NDK}\"
is_official_build=true
is_debug=false
skia_enable_pdf=false
skia_enable_discrete_gpu=false
skia_enable_ganesh=false
skia_enable_skottie=false
skia_enable_skshaper=false
skia_use_dng_sdk=false
skia_use_expat=false
skia_use_freetype=false
skia_use_fontconfig=false
skia_use_fonthost_mac=false
skia_use_gl=false
skia_use_harfbuzz=false
skia_use_icu=false
skia_use_libjpeg_turbo_encode=false
skia_use_libjpeg_turbo_decode=false
skia_use_libpng_encode=false
skia_use_libpng_decode=false
skia_use_libwebp_encode=false
skia_use_libwebp_decode=false
skia_use_piex=false
skia_use_xps=false
skia_use_zlib=false
skia_enable_spirv_validation=false
skia_use_lua=false
skia_use_wuffs=false
skia_enable_fontmgr_empty=true
extra_cflags=[\"-DSK_DISABLE_LEGACY_PNG_WRITEBUFFER\", \"-I${TERMUX_PREFIX}/include\"]
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

	export SETUPTOOLS_SCM_PRETEND_VERSION="${TERMUX_PKG_VERSION}"
	export BUILD_SKIA_FROM_SOURCE=0
	export SKIA_LIBRARY_DIR=$_SKIA_REPO_DIR/out
	LDFLAGS+=" -llog"
	CXXFLAGS+=" -I${TERMUX_PREFIX}/include/python${TERMUX_PYTHON_VERSION}/"
}

termux_step_make() {
	git clone --branch $_SKIA_REPO_BRANCH ${_SKIA_REPO_URL#git+} $_SKIA_REPO_DIR
	cd $_SKIA_REPO_DIR
	git checkout $_SKIA_REPO_COMMIT

	sed -i 's|rebase_path("//bin/gn")|"gn"|g' BUILD.gn
	gn gen out "--args=${TERMUX_PKG_EXTRA_CONFIGURE_ARGS}"
	ninja -C out
}
