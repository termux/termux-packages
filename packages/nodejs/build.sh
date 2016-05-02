TERMUX_PKG_HOMEPAGE=http://nodejs.org/
TERMUX_PKG_DESCRIPTION="Platform built on Chrome's JavaScript runtime for easily building fast, scalable network applications"
TERMUX_PKG_VERSION=6.0.0
TERMUX_PKG_BUILD_REVISION=3
TERMUX_PKG_SRCURL=https://nodejs.org/dist/v${TERMUX_PKG_VERSION}/node-v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="openssl, libuv, libgnustl, c-ares"
TERMUX_PKG_RM_AFTER_INSTALL="lib/node_modules/npm/html lib/node_modules/npm/make.bat share/systemtap lib/dtrace"
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_configure () {
	# https://github.com/nodejs/build/issues/266: "V8 can handle cross compiling of
	# snapshots if the {CC,CXX}_host variables are defined, by compiling the
	# mksnapshot executable with the host compiler". But this currently fails
	# due to the host build picking up targets flags.
	export CC_host=gcc
	export CXX_host=g++

	local _EXTRA_CONFIGURE_ARGS=""
	if [ $TERMUX_ARCH = "arm" ]; then
		DEST_CPU="arm"
		_EXTRA_CONFIGURE_ARGS=" --with-arm-float-abi=hard --with-arm-fpu=neon"
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

	./configure \
		--prefix=$TERMUX_PREFIX \
		--dest-cpu=$DEST_CPU \
		--dest-os=android \
		--shared-openssl --shared-zlib --shared-libuv --shared-cares \
		--without-snapshot \
		$_EXTRA_CONFIGURE_ARGS
}
