TERMUX_PKG_HOMEPAGE=https://opencolorio.org
TERMUX_PKG_DESCRIPTION="A color management framework for visual effects and animation"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.2.1
TERMUX_PKG_SRCURL=https://github.com/AcademySoftwareFoundation/OpenColorIO/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=36f27c5887fc4e5c241805c29b8b8e68725aa05520bcaa7c7ec84c0422b8580e
TERMUX_PKG_DEPENDS="imath, libc++, libexpat, libminizip-ng, libyaml-cpp, pystring"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dpystring_INCLUDE_DIR=$TERMUX_PREFIX/lib
-DOCIO_BUILD_PYTHON=OFF
"
# Command-line apps depend on packages in x11 repo (for OpenGL functionality):
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DOCIO_BUILD_APPS=OFF"
