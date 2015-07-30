TERMUX_PKG_HOMEPAGE=https://iojs.org
TERMUX_PKG_DESCRIPTION="An npm compatibe platform base on node.js"
TERMUX_PKG_VERSION=2.5.0
TERMUX_PKG_SRCURL=https://iojs.org/dist/v${TERMUX_PKG_VERSION}/iojs-v${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--dest-os=android --shared-openssl --shared-zlib --shared-libuv --without-snapshot"
TERMUX_PKG_DEPENDS="c-ares, openssl, libuv"
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
