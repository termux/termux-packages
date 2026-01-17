TERMUX_PKG_HOMEPAGE=https://manim.community
TERMUX_PKG_DESCRIPTION="A community-maintained Python framework for creating mathematical animations"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Nguyen Khanh @nguynkhn"
TERMUX_PKG_VERSION="0.19.2"
TERMUX_PKG_SRCURL=https://github.com/ManimCommunity/manim/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=e61992a84c684702ce732e66ae46f85341ebe4cb208f8a4c5cb33ce9ea070f02
TERMUX_PKG_DEPENDS="ffmpeg, libcairo, pango, xorgproto, python-numpy, python-pillow, pycairo, python-scipy, python-skia-pathops"
TERMUX_PKG_SUGGESTS="texlive-installer"
TERMUX_PKG_PYTHON_TARGET_DEPS="'av>=9.0.0,<14.0.0', 'beautifulsoup4>=4.12', 'click>=8.0', 'cloup>=2.0.0', 'decorator>=4.3.2', 'importlib-metadata>=8.6.1', 'isosurfaces>=0.1.0', 'manimpango>=0.5.0,<1.0.0', 'mapbox-earcut>=1.0.0,<1.0.3', 'moderngl-window>=2.0.0', 'moderngl>=5.0.0,<6.0.0', 'networkx>=2.6', 'pydub>=0.20.0', 'pygments>=2.0.0', 'rich>=12.0.0', 'screeninfo>=0.7', 'srt>=3.0.0', 'svgelements>=1.8.0', 'tqdm>=4.0.0', 'typing-extensions>=4.12.0', 'watchdog>=2.0.0'"
TERMUX_PKG_PYTHON_COMMON_DEPS="poetry"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXCLUDED_ARCHES="arm, i686"

termux_step_create_debscripts() {
	cat <<- EOF > ./postinst
	#!$TERMUX_PREFIX/bin/sh
	echo "Installing dependencies through pip..."
	pip3 install ${TERMUX_PKG_PYTHON_TARGET_DEPS//, / }
	EOF
}
