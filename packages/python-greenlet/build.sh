TERMUX_PKG_HOMEPAGE=https://github.com/python-greenlet/greenlet
TERMUX_PKG_DESCRIPTION="Lightweight coroutines for in-process concurrent programming"
# Licenses: MIT, PSF-2.0
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="LICENSE, LICENSE.PSF"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.0.2
TERMUX_PKG_SRCURL=https://github.com/python-greenlet/greenlet/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=25706d0da2708117570ccc83b478a1ad7dda35c78dfb8eef3a7c53e89d1b36a4
TERMUX_PKG_DEPENDS="libc++, python"
TERMUX_PKG_PYTHON_COMMON_DEPS="wheel"
TERMUX_PKG_BUILD_IN_SRC=true
