TERMUX_PKG_HOMEPAGE=https://github.com/joyent/libuv
TERMUX_PKG_DESCRIPTION="Support library with a focus on asynchronous I/O"
TERMUX_PKG_VERSION=1.9.0
TERMUX_PKG_SRCURL=http://dist.libuv.org/dist/v${TERMUX_PKG_VERSION}/libuv-v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-dtrace" # needed for building on mac

termux_step_pre_configure () {
	export LINK=$CXX
	export PLATFORM=android
	cd $TERMUX_PKG_SRCDIR
	sh autogen.sh
}

termux_step_post_make_install () {
	# The installed include/uv-unix includes pthread-fixes.h inside ifdef __ANDROID__
	cp $TERMUX_PKG_SRCDIR/include/pthread-fixes.h $TERMUX_PREFIX/include
}
