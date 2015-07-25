TERMUX_PKG_HOMEPAGE=http://nodejs.org/
TERMUX_PKG_DESCRIPTION="Platform built on Chrome's JavaScript runtime for easily building fast, scalable network applications"
TERMUX_PKG_VERSION=0.12.7
TERMUX_PKG_BUILD_REVISION=1
TERMUX_PKG_SRCURL=http://nodejs.org/dist/v${TERMUX_PKG_VERSION}/node-v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--dest-os=android --shared-openssl --shared-zlib --shared-cares --shared-libuv --without-snapshot"
TERMUX_PKG_DEPENDS="c-ares, openssl, libuv"
TERMUX_PKG_RM_AFTER_INSTALL="lib/node_modules/npm/html lib/node_modules/npm/make.bat share/systemtap lib/dtrace"
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_configure () {
	if [ $TERMUX_ARCH = "arm" ]; then
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --dest-cpu=arm"
	elif [ $TERMUX_ARCH = "i686" ]; then
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --dest-cpu=ia32"
	else
		echo "Unsupported arch: $TERMUX_ARCH"
		exit 1
	fi
	# Some v8 code checks for ANDROID instead of __ANDROID__:
	export CFLAGS="$CFLAGS -DANDROID=1"
	export CXXFLAGS="$CXXFLAGS -DANDROID=1"
	# The cc_macros() function in configure executes $CC to look at features such as armv7 and neon:
	export CC="$CC $CFLAGS"
	# To avoid build process trying to use linux-specific flock which breaks build on mac:
	export LINK=$CXX
	env $TERMUX_PKG_SRCDIR/configure \
		--prefix=$TERMUX_PREFIX \
		${TERMUX_PKG_EXTRA_CONFIGURE_ARGS}
}
