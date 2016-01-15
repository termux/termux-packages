TERMUX_PKG_HOMEPAGE=http://nodejs.org/
TERMUX_PKG_DESCRIPTION="Platform built on Chrome's JavaScript runtime for easily building fast, scalable network applications"
TERMUX_PKG_VERSION=5.4.1
TERMUX_PKG_SRCURL=https://nodejs.org/dist/v${TERMUX_PKG_VERSION}/node-v${TERMUX_PKG_VERSION}.tar.gz
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

	# https://github.com/nodejs/build/issues/266: "V8 can handle cross compiling of
	# snapshots if the {CC,CXX}_host variables are defined, by compiling the
	# mksnapshot executable with the host compiler". But this currently fails
	# due to the host build picking up targets flags.
	export CC_host=gcc
	export CXX_host=g++

	if [ $TERMUX_ARCH = "arm" ]; then
		DEST_CPU="arm"
	elif [ $TERMUX_ARCH = "i686" ]; then
		DEST_CPU="ia32"
	elif [ $TERMUX_ARCH = "aarch64" ]; then
		DEST_CPU="arm64"
	elif [ $TERMUX_ARCH = "x86_64" ]; then
		DEST_CPU="x64"
	else
		echo "Unsupported arch: $TERMUX_ARCH"
		exit 1
	fi

	#LDFLAGS+=" -lstlport_static"

	./configure \
		--prefix=$TERMUX_PREFIX \
		--dest-cpu=$DEST_CPU \
		--dest-os=android \
		--shared-openssl --shared-zlib --shared-libuv \
		--without-snapshot
}

termux_step_post_massage () {
	test -d $TERMUX_PKG_CACHEDIR/gtest-include-dir &&
		mv $TERMUX_PKG_CACHEDIR/gtest-include-dir $TERMUX_PREFIX/include/gtest
	test -d $TERMUX_PKG_CACHEDIR/ares-includes &&
		mv $TERMUX_PKG_CACHEDIR/ares-includes/* $TERMUX_PREFIX/include/
	# Exit with success to avoid aborting script due to set -e:
	true
}
