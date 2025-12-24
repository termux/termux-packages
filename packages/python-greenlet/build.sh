TERMUX_PKG_HOMEPAGE=https://github.com/python-greenlet/greenlet
TERMUX_PKG_DESCRIPTION="Lightweight coroutines for in-process concurrent programming"
# Licenses: MIT, PSF-2.0
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="LICENSE, LICENSE.PSF"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.3.0"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/python-greenlet/greenlet/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=5d854395dc71b38a22e7e25467e7fc66e6a6fe538165318416cd2bb892692c6c
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
TERMUX_PKG_DEPENDS="libc++, python, python-pip"
TERMUX_PKG_PYTHON_COMMON_DEPS="wheel"
TERMUX_PKG_BUILD_IN_SRC=true
