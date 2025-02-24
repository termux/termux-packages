TERMUX_PKG_HOMEPAGE=https://manim.community
TERMUX_PKG_DESCRIPTION="A community-maintained Python framework for creating mathematical animations"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Nguyen Khanh @nguynkhn"
TERMUX_PKG_VERSION="0.19.0"
TERMUX_PKG_SRCURL=https://github.com/ManimCommunity/manim/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=9047d87bb5ac9d008d22f5d444b984e5b630585a073d69506ef0164c804df2c3
TERMUX_PKG_DEPENDS="ffmpeg, libcairo, pango, xorgproto, python-numpy, python-pillow, pycairo, python-scipy, python-skia-pathops"
TERMUX_PKG_RECOMMENDS="texlive-installer"
TERMUX_PKG_PYTHON_TARGET_DEPS="'av==12.3.0', click, cloup, decorator, importlib-metadata, isosurfaces, 'manimpango<1.0.0', mapbox-earcut, moderngl, moderngl-window, networkx, pydub, Pygments, rich, screeninfo, srt, svgelements, tqdm, typing-extensions, watchdog"
TERMUX_PKG_PYTHON_COMMON_DEPS="poetry"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BLACKLISTED_ARCHES="arm, i686"

termux_step_create_debscripts() {
	cat <<- EOF > ./postinst
	#!$TERMUX_PREFIX/bin/sh
	echo "Installing dependencies through pip..."
	pip3 install ${TERMUX_PKG_PYTHON_TARGET_DEPS//, / }
	EOF
}
