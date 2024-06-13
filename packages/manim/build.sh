TERMUX_PKG_HOMEPAGE=https://manim.community
TERMUX_PKG_DESCRIPTION="A community-maintained Python framework for creating mathematical animations"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Nguyen Khanh @nguynkhn"
TERMUX_PKG_VERSION=0.18.1
TERMUX_PKG_SRCURL=https://github.com/manimCommunity/manim/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=36ce308b92bbbe039ee8cf4fbad5a8ba0ec5f24c9cf2919fab0fc5df92be7655
TERMUX_PKG_DEPENDS="libc++, ffmpeg, libcairo, pango, xorgproto, python-numpy, python-pillow, pycairo, python-scipy, python-pip"
TERMUX_PKG_RECOMMENDS="texlive-installer"
TERMUX_PKG_PYTHON_TARGET_DEPS="av, click, cloup, decorator, importlib-metadata, isosurfaces, manimpango, mapbox-earcut, moderngl, moderngl-window, networkx, pydub, Pygments, rich, screeninfo, skia-pathops, srt, svgelements, tqdm, typing-extensions, watchdog"
TERMUX_PKG_PYTHON_COMMON_DEPS="poetry"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

_SKIA_REPO_URL=git+https://github.com/fonttools/skia
_SKIA_REPO_BRANCH=chrome/m113-fix-win-x86-no-deps
_SKIA_REPO_COMMIT=d9ab9420effbf3b73792671db130fa6f617cbf72
_SKIA_BUILD_ARGS="
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

termux_step_post_get_source() {
	git clone --depth 1 --branch $_SKIA_REPO_BRANCH ${_SKIA_REPO_URL#git+} $TERMUX_PKG_SRCDIR/skia

	cd $TERMUX_PKG_SRCDIR/skia
	git fetch --unshallow
	git checkout $_SKIA_REPO_COMMIT
}

termux_step_make() {
	termux_setup_gn

	local _arch=$TERMUX_ARCH
	if [ "$TERMUX_ARCH" = "i686" ]; then
		_arch="x86"
	elif [ "$TERMUX_ARCH" = "x86_64" ]; then
		_arch="x64"
	elif [ "$TERMUX_ARCH" = "aarch64" ]; then
		_arch="arm64"
	fi
	_SKIA_BUILD_ARGS+="ndk=\"${NDK}\" target_cpu=\"$_arch\""

	pushd $TERMUX_PKG_SRCDIR/skia
	gn gen out/build "--args=${_SKIA_BUILD_ARGS//$'\n'/ }"
	ninja -C out/build
	popd
}

termux_step_make_install() {
	install -Dm600 $TERMUX_PKG_SRCDIR/skia/out/build/libskia.a $TERMUX_PREFIX/lib/libskia.a
	pip install --no-deps --no-build-isolation . --prefix $TERMUX_PREFIX
}

termux_step_create_debscripts() {
	cat <<- EOF > ./postinst
	#!$TERMUX_PREFIX/bin/sh
	echo "Installing dependencies through pip..."
	LDFLAGS=-llog BUILD_SKIA_FROM_SOURCE=0 SKIA_LIBRARY_DIR=$TERMUX_PREFIX/lib pip3 install ${TERMUX_PKG_PYTHON_TARGET_DEPS//, / }
	rm -f $TERMUX_PREFIX/lib/libskia.a
	EOF
}
