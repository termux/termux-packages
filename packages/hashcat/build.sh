TERMUX_PKG_HOMEPAGE=https://hashcat.net/hashcat
TERMUX_PKG_DESCRIPTION="World's fastest and most advanced password recovery utility"
TERMUX_PKG_VERSION=4.0.0
TERMUX_PKG_SHA256=05a87eb018507b24afca970081f067e64441460319fb75ca1e64c4a1f322b80b
TERMUX_PKG_SRCURL=https://github.com/hashcat/hashcat/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_BUILD_IN_SRC=yes


termux_step_post_configure () {

	mkdir -p $TERMUX_PREFIX/include/CL
	curl -L https://raw.githubusercontent.com/KhronosGroup/OpenCL-Headers/master/opencl11/CL/cl.h -o $TERMUX_PREFIX/include/CL
	curl -L https://raw.githubusercontent.com/KhronosGroup/OpenCL-Headers/master/opencl11/CL/cl_platform.h -o $TERMUX_PREFIX/include/C

}
