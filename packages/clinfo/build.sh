TERMUX_PKG_HOMEPAGE=https://github.com/Oblomov/clinfo
TERMUX_PKG_DESCRIPTION="Print all known information about all available OpenCL platforms and devices in the system"
TERMUX_PKG_LICENSE="CC0-1.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.0.21.02.21
TERMUX_PKG_SRCURL=https://github.com/Oblomov/clinfo/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=e52f5c374a10364999d57a1be30219b47fb0b4f090e418f2ca19a0c037c1e694
TERMUX_PKG_BUILD_DEPENDS="opencl-headers"
TERMUX_PKG_DEPENDS="ocl-icd"
TERMUX_PKG_BUILD_IN_SRC=true

# https://github.com/Oblomov/clinfo/blob/master/Makefile#L7
# clinfo has added detection for building on device
# and wrapper for running on device
# which directly link against /vendor/lib64/libOpenCL.so
# This conflicts with using ocl-icd
TERMUX_PKG_EXTRA_MAKE_ARGS="OS=Linux"
