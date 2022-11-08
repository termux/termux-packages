TERMUX_PKG_HOMEPAGE=https://opencolorio.org
TERMUX_PKG_DESCRIPTION="A color management framework for visual effects and animation"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.1.2
TERMUX_PKG_SRCURL=https://github.com/AcademySoftwareFoundation/OpenColorIO/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=6c6d153470a7dbe56136073e7abea42fa34d06edc519ffc0a159daf9f9962b0b
TERMUX_PKG_DEPENDS="libc++, freeglut, glew, littlecms, libtinyxml2, libyaml-cpp, imath, libexpat, pystring"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-Dpystring_INCLUDE_DIR=$TERMUX_PREFIX/lib/ -DOCIO_BUILD_PYTHON=off"
