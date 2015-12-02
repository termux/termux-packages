TERMUX_PKG_HOMEPAGE=http://nodejs.org/
TERMUX_PKG_DESCRIPTION="Platform built on Chrome's JavaScript runtime for easily building fast, scalable network applications"
TERMUX_PKG_VERSION=4.2.2
TERMUX_PKG_SRCURL=https://nodejs.org/dist/v${TERMUX_PKG_VERSION}/node-v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--dest-os=android --shared-openssl --shared-zlib --shared-libuv"
TERMUX_PKG_DEPENDS="openssl, libuv"
TERMUX_PKG_RM_AFTER_INSTALL="lib/node_modules/npm/html lib/node_modules/npm/make.bat share/systemtap lib/dtrace"
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_configure () {
	#FIXME: node.js build does not handle already installed headers
	#       https://github.com/nodejs/node/issues/2637
	rm -Rf $TERMUX_PREFIX/{include/gtest/,/include/ares*}

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
