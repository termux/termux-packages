TERMUX_PKG_HOMEPAGE=https://github.com/python-greenlet/greenlet
TERMUX_PKG_DESCRIPTION="Lightweight coroutines for in-process concurrent programming"
# Licenses: MIT, PSF-2.0
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="LICENSE, LICENSE.PSF"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.2.4"
TERMUX_PKG_SRCURL=https://github.com/python-greenlet/greenlet/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=72b20876a114c0d12683edacac3e8aa329639bae2835902ee9da92a899847b1f
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
TERMUX_PKG_DEPENDS="libc++, python"
TERMUX_PKG_PYTHON_COMMON_DEPS="wheel"
TERMUX_PKG_BUILD_IN_SRC=true
