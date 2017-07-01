# status: Does not build
TERMUX_PKG_HOMEPAGE=https://nodejs.org/
TERMUX_PKG_DESCRIPTION="Platform built on Chrome's JavaScript runtime for easily building fast, scalable network applications"
TERMUX_PKG_VERSION=8.1.0
TERMUX_PKG_SRCURL=https://nodejs.org/dist/v${TERMUX_PKG_VERSION}/node-v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=6886d0891ee1a46c41f1095ffbbd6cb8871a1b18b61712b5bf7d6bf5018d64de
# Note that we do not use a shared libuv to avoid an issue with the Android
# linker, which does not use symbols of linked shared libraries when resolving
# symbols on dlopen(). See https://github.com/termux/termux-packages/issues/462.
TERMUX_PKG_DEPENDS="openssl, c-ares"
TERMUX_PKG_RM_AFTER_INSTALL="lib/node_modules/npm/html lib/node_modules/npm/make.bat share/systemtap lib/dtrace"
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_CONFLICTS="nodejs"

termux_step_configure () {
	# See https://github.com/nodejs/build/issues/266 about enabling snapshots
	# when cross compiling. We use {CC,CXX}_host for compilation of code to
	# be run on the build maching (snapshots when cross compiling are
	# generated using a CPU emulator provided by v8) and {CC,CXX} for the
	# cross compile. We unset flags such as CFLAGS as they would affect
	# both the host and cross compiled build.
	# Remaining issue to be solved before enabling snapshots by removing
	# the --without-snapshot flag is that pkg-config picks up cross compilation
	# flags which breaks the host build.
	export CC_host="gcc -pthread"
	export CXX_host="g++ -pthread"
	export CC="$CC $CFLAGS $CPPFLAGS $LDFLAGS"
	export CXX="$CXX $CXXFLAGS $CPPFLAGS $LDFLAGS"
	export CFLAGS="-Os"
	export CXXFLAGS="-Os"
	unset CPPFLAGS LDFLAGS

	if [ $TERMUX_ARCH = "arm" ]; then
		DEST_CPU="arm"
	elif [ $TERMUX_ARCH = "i686" ]; then
		DEST_CPU="ia32"
	elif [ $TERMUX_ARCH = "aarch64" ]; then
		DEST_CPU="arm64"
	elif [ $TERMUX_ARCH = "x86_64" ]; then
		DEST_CPU="x64"
	else
		termux_error_exit "Unsupported arch '$TERMUX_ARCH'"
	fi

	export GYP_DEFINES="host_os=linux"

	# See note above TERMUX_PKG_DEPENDS why we do not use a shared libuv.
	./configure \
		--prefix=$TERMUX_PREFIX \
		--dest-cpu=$DEST_CPU \
		--dest-os=android \
		--shared-cares \
		--shared-openssl \
		--shared-zlib \
		--without-inspector \
		--without-intl \
		--cross-compiling
}
