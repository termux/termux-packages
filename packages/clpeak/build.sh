TERMUX_PKG_HOMEPAGE=https://github.com/krrishnarraj/clpeak
TERMUX_PKG_DESCRIPTION="A tool which profiles OpenCL devices to find their peak capacities"
TERMUX_PKG_LICENSE="Unlicense"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.0.0"
TERMUX_PKG_SRCURL="https://github.com/krrishnarraj/clpeak/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=48fd24e47b1af4159bd4a0ea5abe9c2ed9e280bef67d9a5ff9ab5b30de5ad58a
TERMUX_PKG_DEPENDS="libc++, ocl-icd"
TERMUX_PKG_BUILD_DEPENDS="opencl-headers, opencl-clhpp"
TERMUX_PKG_AUTO_UPDATE=true

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DCLPEAK_ENABLE_LITERT=OFF"
