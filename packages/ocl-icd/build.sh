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
# On Android, libOpenCL.so usually lives in /vendor/lib{,64} and
# requires exporting LD_LIBRARY_PATH env var to work
# This means that OpenCL never worked in Termux without prepping upfront

# ocl-icd also does not provide vendor specific ICD file out of the box

# Hence the provided ICD file will be removed in ocl-icd
# PREFIX/etc/OpenCL/vendors dir will also be removed
# This matches desktop Linux behaviour

# Driver packages (or users) themselves are expected to create ICD files
# They also need to handle creation of PREFIX/etc/OpenCL/vendors directory
# Though users can override the default by exporting OPENCL_VENDOR_PATH env var
