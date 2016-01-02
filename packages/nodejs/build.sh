TERMUX_PKG_HOMEPAGE=http://nodejs.org/
TERMUX_PKG_DESCRIPTION="Platform built on Chrome's JavaScript runtime for easily building fast, scalable network applications"
TERMUX_PKG_VERSION=4.2.3
TERMUX_PKG_SRCURL=https://nodejs.org/dist/v${TERMUX_PKG_VERSION}/node-v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--dest-os=android --shared-openssl --shared-zlib --shared-libuv"
TERMUX_PKG_DEPENDS="openssl, libuv"
TERMUX_PKG_RM_AFTER_INSTALL="lib/node_modules/npm/html lib/node_modules/npm/make.bat share/systemtap lib/dtrace"
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_configure () {
	#XXX: node.js build does not handle already installed headers
	#     https://github.com/nodejs/node/issues/2637
	#     So we remove them here and restore afterwards.
	rm -Rf $TERMUX_PKG_CACHEDIR/gtest-include-dir $TERMUX_PKG_CACHEDIR/ares-includes
	test -d $TERMUX_PREFIX/include/gtest &&
		mv $TERMUX_PREFIX/include/gtest $TERMUX_PKG_CACHEDIR/gtest-include-dir
	test -f $TERMUX_PREFIX/include/ares.h &&
		mkdir $TERMUX_PKG_CACHEDIR/ares-includes/ &&
		mv $TERMUX_PREFIX/include/ares* $TERMUX_PKG_CACHEDIR/ares-includes/

	if [ $TERMUX_ARCH = "arm" ]; then
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --dest-cpu=arm"
	elif [ $TERMUX_ARCH = "i686" ]; then
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --dest-cpu=ia32"
	elif [ $TERMUX_ARCH = "aarch64" ]; then
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --dest-cpu=arm64"
	elif [ $TERMUX_ARCH = "x86_64" ]; then
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --dest-cpu=x64"
	else
		echo "Unsupported arch: $TERMUX_ARCH"
		exit 1
	fi

	./configure --prefix=$TERMUX_PREFIX ${TERMUX_PKG_EXTRA_CONFIGURE_ARGS}
}

termux_step_post_massage () {
	test -d $TERMUX_PKG_CACHEDIR/gtest-include-dir &&
		mv $TERMUX_PKG_CACHEDIR/gtest-include-dir $TERMUX_PREFIX/include/gtest
	test -d $TERMUX_PKG_CACHEDIR/ares-includes &&
		mv $TERMUX_PKG_CACHEDIR/ares-includes/* $TERMUX_PREFIX/include/
}
