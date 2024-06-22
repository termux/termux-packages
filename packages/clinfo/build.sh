TERMUX_PKG_HOMEPAGE=https://github.com/Oblomov/clinfo
TERMUX_PKG_DESCRIPTION="Print all known information about all available OpenCL platforms and devices in the system"
TERMUX_PKG_LICENSE="CC0-1.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.0.23.01.25
TERMUX_PKG_SRCURL=https://github.com/Oblomov/clinfo/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=6dcdada6c115873db78c7ffc62b9fc1ee7a2d08854a3bccea396df312e7331e3
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
TERMUX_PKG_BUILD_DEPENDS="opencl-headers"
TERMUX_PKG_DEPENDS="ocl-icd"
TERMUX_PKG_BUILD_IN_SRC=true

# https://github.com/Oblomov/clinfo/blob/master/Makefile#L7
# clinfo has added detection for building on device
# and wrapper for running on device
# which directly link against /vendor/lib64/libOpenCL.so
# This conflicts with using ocl-icd
TERMUX_PKG_EXTRA_MAKE_ARGS="OS=Linux"

TERMUX_PKG_EXTRA_MAKE_ARGS+="
MANDIR=$TERMUX_PREFIX/share/man
"
