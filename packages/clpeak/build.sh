TERMUX_PKG_HOMEPAGE=https://github.com/krrishnarraj/clpeak
TERMUX_PKG_DESCRIPTION="A tool which profiles OpenCL devices to find their peak capacities"
TERMUX_PKG_LICENSE="Unlicense"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.0.3"
TERMUX_PKG_SRCURL="https://github.com/krrishnarraj/clpeak/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=eaabf5b4d54a4b3cdf1106731036f7be7c58b939f24217339f6e1c51969eac34
TERMUX_PKG_DEPENDS="libc++, ocl-icd"
TERMUX_PKG_BUILD_DEPENDS="opencl-headers, opencl-clhpp"
TERMUX_PKG_AUTO_UPDATE=true

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DCLPEAK_ENABLE_LITERT=OFF"
