TERMUX_PKG_HOMEPAGE=https://nodejs.org/
TERMUX_PKG_DESCRIPTION="Platform built on Chrome's JavaScript runtime for easily building fast, scalable network applications"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_VERSION=10.16.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SHA256=18e37f891d10ea7fbc8f6410c444c2b1d9cc3cbbb1d35aa9c41f761816956608
TERMUX_PKG_SRCURL=https://nodejs.org/dist/v${TERMUX_PKG_VERSION}/node-v${TERMUX_PKG_VERSION}.tar.xz
# Note that we do not use a shared libuv to avoid an issue with the Android
# linker, which does not use symbols of linked shared libraries when resolving
# symbols on dlopen(). See https://github.com/termux/termux-packages/issues/462.
TERMUX_PKG_DEPENDS="openssl, c-ares, libicu, zlib"
TERMUX_PKG_RM_AFTER_INSTALL="lib/node_modules/npm/html lib/node_modules/npm/make.bat share/systemtap lib/dtrace"
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_CONFLICTS="nodejs"

termux_step_configure() {
	local DEST_CPU
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
	export CC_host=gcc
	export CXX_host=g++
	export LINK_host=g++

	# See note above TERMUX_PKG_DEPENDS why we do not use a shared libuv.
	./configure \
		--prefix=$TERMUX_PREFIX \
		--dest-cpu=$DEST_CPU \
		--dest-os=android \
		--shared-cares \
		--shared-openssl \
		--shared-zlib \
		--with-intl=system-icu \
		--without-snapshot \
		--cross-compiling

	perl -p -i -e 's/LIBS := \$\(LIBS\)/LIBS := -lpthread/' \
		$TERMUX_PKG_SRCDIR/out/deps/v8/gypfiles/torque.host.mk
}
