TERMUX_PKG_HOMEPAGE=https://github.com/ManimCommunity/ManimPango
TERMUX_PKG_DESCRIPTION="Binding for Pango, to use with Manim."
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Nguyen Khanh @nguynkhn"
TERMUX_PKG_VERSION="0.7.1"
TERMUX_PKG_SRCURL="https://github.com/ManimCommunity/ManimPango/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=7cb0a3c72232aa3e764981fe24ca216b4460e2aba89f5d5d58659dfbeca83541
TERMUX_PKG_DEPENDS="pango, python, python-pip"
TERMUX_PKG_PYTHON_COMMON_BUILD_DEPS="'Cython>=3.0.2,<3.1'"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXCLUDED_ARCHES="arm, i686"
