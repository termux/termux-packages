TERMUX_PKG_HOMEPAGE=https://opencolorio.org
TERMUX_PKG_DESCRIPTION="A color management framework for visual effects and animation"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.2.0
TERMUX_PKG_SRCURL=https://github.com/AcademySoftwareFoundation/OpenColorIO/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=81e3b6e0e432d20347b6396c376f9fbeceac31c2cbefe2882d83112a5b0a8123
TERMUX_PKG_DEPENDS="imath, libc++, libexpat, libminizip-ng, libyaml-cpp, pystring"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dpystring_INCLUDE_DIR=$TERMUX_PREFIX/lib
-DOCIO_BUILD_PYTHON=OFF
"
# Command-line apps depend on packages in x11 repo (for OpenGL functionality):
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DOCIO_BUILD_APPS=OFF"
