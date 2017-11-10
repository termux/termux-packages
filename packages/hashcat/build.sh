TERMUX_PKG_HOMEPAGE=https://hashcat.net/hashcat
TERMUX_PKG_DESCRIPTION="World's fastest and most advanced password recovery utility"
TERMUX_PKG_VERSION=4.0.0
TERMUX_PKG_SHA256=e14c169d6966830e7b7423e17e678f3333e074ec50dae50bdde40e8e0e8658be
TERMUX_PKG_SRCURL=https://github.com/hashcat/hashcat/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="libandroid-support, libandroid-support-dev"
TERMUX_PKG_BUILD_IN_SRC=yes


termux_step_post_configure () {

	mkdir -p $TERMUX_PREFIX/include/CL
	mv ./cl.h $TERMUX_PREFIX/include/CL/
	mv ./cl_platform.h $TERMUX_PREFIX/include/CL

}
