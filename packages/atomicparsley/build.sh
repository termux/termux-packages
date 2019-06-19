TERMUX_PKG_HOMEPAGE=https://bitbucket.org/wez/atomicparsley
TERMUX_PKG_DESCRIPTION="Read, parse and set metadata of MPEG-4 and 3gp files"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=0.9.6
TERMUX_PKG_REVISION=5
TERMUX_PKG_SRCURL=https://bitbucket.org/wez/atomicparsley/get/${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=e28d46728be86219e6ce48695ea637d831ca0170ca6bdac99810996a8291ee50
TERMUX_PKG_DEPENDS="libc++, zlib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_cv_func_lroundf=yes"

termux_step_pre_configure() {
	./autogen.sh

	# Avoid the configure script from using g++ for linking:
	export OBJCXX=$CXX
}
