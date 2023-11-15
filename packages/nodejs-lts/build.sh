TERMUX_PKG_HOMEPAGE=https://nodejs.org/
TERMUX_PKG_DESCRIPTION="Open Source, cross-platform JavaScript runtime environment"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Yaksh Bariya <thunder-coding@termux.dev>"
TERMUX_PKG_VERSION=18.16.1
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://nodejs.org/dist/v${TERMUX_PKG_VERSION}/node-v${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=e8404f8c8d89fdfdf7e95bbbc6066bd0e571acba58f54492599b615fbeefe272
# Note that we do not use a shared libuv to avoid an issue with the Android
# linker, which does not use symbols of linked shared libraries when resolving
# symbols on dlopen(). See https://github.com/termux/termux-packages/issues/462.
TERMUX_PKG_DEPENDS="libc++, openssl, c-ares, libicu, zlib"
TERMUX_PKG_CONFLICTS="nodejs, nodejs-current"
TERMUX_PKG_BREAKS="nodejs-dev"
TERMUX_PKG_REPLACES="nodejs-current, nodejs-dev"
TERMUX_PKG_SUGGESTS="clang, make, pkg-config, python"
TERMUX_PKG_RM_AFTER_INSTALL="lib/node_modules/npm/html lib/node_modules/npm/make.bat share/systemtap lib/dtrace"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	termux_setup_ninja
}

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

	# See note above TERMUX_PKG_DEPENDS why we do not use a shared libuv
	# When building with ninja, build.ninja is geenrated for both Debug and Release builds.
	./configure \
		--prefix=$TERMUX_PREFIX \
		--dest-cpu=$DEST_CPU \
		--dest-os=android \
		--shared-cares \
		--shared-openssl \
		--shared-zlib \
		--with-intl=system-icu \
		--cross-compiling \
		--ninja

	sed -i -e "s|\-I$TERMUX_PREFIX/include||g" \
		$TERMUX_PKG_SRCDIR/out/Release/obj.host/tools/v8_gypfiles/*.ninja
	sed -i -e "s|\-L$TERMUX_PREFIX/lib||g" \
		$TERMUX_PKG_SRCDIR/out/Release/obj.host/tools/v8_gypfiles/*.ninja
}

termux_step_make() {
	if [ "${TERMUX_DEBUG_BUILD}" = "true" ]; then
		ninja -C out/Debug -j "${TERMUX_MAKE_PROCESSES}"
	else
		ninja -C out/Release -j "${TERMUX_MAKE_PROCESSES}"
	fi
}

termux_step_make_install() {
	if [ "${TERMUX_DEBUG_BUILD}" = "true" ]; then
		python tools/install.py install "" "${TERMUX_PREFIX}" out/Debug/
	else
		python tools/install.py install "" "${TERMUX_PREFIX}" out/Release/
	fi
}

termux_step_create_debscripts() {
	cat <<- EOF > ./postinst
	#!$TERMUX_PREFIX/bin/sh
	npm config set foreground-scripts true
	EOF
}
