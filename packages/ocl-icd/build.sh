TERMUX_PKG_HOMEPAGE=https://github.com/OCL-dev/ocl-icd
TERMUX_PKG_DESCRIPTION="OpenCL ICD Loader"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.3.1
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/OCL-dev/ocl-icd/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=a32b67c2d52ffbaf490be9fc18b46428ab807ab11eff7664d7ff75e06cfafd6d
TERMUX_PKG_NO_STATICSPLIT=true
TERMUX_PKG_BUILD_DEPENDS="opencl-headers"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-custom-vendordir=$TERMUX_PREFIX/etc/OpenCL/vendors
"

# https://www.khronos.org/registry/OpenCL/specs/2.2/html/OpenCL_ICD_Installation.html
# Intepreting this as providing library "libOpenCL.so" with SONAME "libOpenCL.so" on Android

termux_step_pre_configure() {
	./bootstrap
}

# https://github.com/termux/termux-packages/issues/7510
# Removed handling of PREFIX/etc/OpenCL/vendors to match Desktop Linux ocl-icd behaviour
# Removed creation of android.icd as it never worked without modifying LD_LIBRARY_PATH on Android
# Driver packages (eg: clvk) should be the one handling the items above
