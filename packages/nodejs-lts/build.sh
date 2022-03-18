TERMUX_PKG_HOMEPAGE=https://nodejs.org/
TERMUX_PKG_DESCRIPTION="Open Source, cross-platform JavaScript runtime environment"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Yaksh Bariya <yakshbari4@gmail.com>"
TERMUX_PKG_VERSION=16.14.2
TERMUX_PKG_SRCURL=https://nodejs.org/dist/v${TERMUX_PKG_VERSION}/node-v${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=e922e215cc68eb5f94d33e8a0b61e2c863b7731cc8600ab955d3822da90ff8d1
# Note that we do not use a shared libuv to avoid an issue with the Android
# linker, which does not use symbols of linked shared libraries when resolving
# symbols on dlopen(). See https://github.com/termux/termux-packages/issues/462.
#
# Node.js 16.x does not support `NODE_OPTIONS=--openssl-legacy-provider` option.
# See https://github.com/termux/termux-packages/issues/9266. Please revert back
# to depending on openssl (instead of openssl-1.1) when migrating to next LTS.
TERMUX_PKG_DEPENDS="libc++, openssl-1.1, c-ares, libicu, zlib"
TERMUX_PKG_CONFLICTS="nodejs, nodejs-current"
TERMUX_PKG_BREAKS="nodejs-dev"
TERMUX_PKG_REPLACES="nodejs-current, nodejs-dev"
TERMUX_PKG_SUGGESTS="clang, make, pkg-config, python"
TERMUX_PKG_PROVIDES="nodejs"
TERMUX_PKG_RM_AFTER_INSTALL="lib/node_modules/npm/html lib/node_modules/npm/make.bat share/systemtap lib/dtrace"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_HOSTBUILD=true

termux_step_post_get_source() {
	# Prevent caching of host build:
	rm -Rf $TERMUX_PKG_HOSTBUILD_DIR
}

termux_step_host_build() {
	local ICU_VERSION=70.1
	local ICU_TAR=icu4c-${ICU_VERSION//./_}-src.tgz
	local ICU_DOWNLOAD=https://github.com/unicode-org/icu/releases/download/release-${ICU_VERSION//./-}/$ICU_TAR
	termux_download \
		$ICU_DOWNLOAD\
		$TERMUX_PKG_CACHEDIR/$ICU_TAR \
		8d205428c17bf13bb535300669ed28b338a157b1c01ae66d31d0d3e2d47c3fd5
	tar xf $TERMUX_PKG_CACHEDIR/$ICU_TAR
	cd icu/source
	if [ "$TERMUX_ARCH_BITS" = 32 ]; then
		./configure --prefix $TERMUX_PKG_HOSTBUILD_DIR/icu-installed \
			--disable-samples \
			--disable-tests \
			--build=i686-pc-linux-gnu "CFLAGS=-m32" "CXXFLAGS=-m32" "LDFLAGS=-m32"
	else
		./configure --prefix $TERMUX_PKG_HOSTBUILD_DIR/icu-installed \
			--disable-samples \
			--disable-tests
	fi
	make -j $TERMUX_MAKE_PROCESSES install
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

	LDFLAGS+=" -ldl"

	local _SHARED_OPENSSL_INCLUDES=$TERMUX_PREFIX/include
	local _SHARED_OPENSSL_LIBPATH=$TERMUX_PREFIX/lib

	if [ "${TERMUX_PKG_VERSION%%.*}" != "16" ]; then
		termux_error_exit 'Please migrate to using openssl (instead of openssl-1.1).'
	else
		_SHARED_OPENSSL_INCLUDES=$TERMUX_PREFIX/include/openssl-1.1
		_SHARED_OPENSSL_LIBPATH=$TERMUX_PREFIX/lib/openssl-1.1
		LDFLAGS="-Wl,-rpath=$_SHARED_OPENSSL_LIBPATH $LDFLAGS"
	fi

	# See note above TERMUX_PKG_DEPENDS why we do not use a shared libuv.
	./configure \
		--prefix=$TERMUX_PREFIX \
		--dest-cpu=$DEST_CPU \
		--dest-os=android \
		--shared-cares \
		--shared-openssl \
		--shared-openssl-includes=$_SHARED_OPENSSL_INCLUDES \
		--shared-openssl-libpath=$_SHARED_OPENSSL_LIBPATH \
		--shared-zlib \
		--with-intl=system-icu \
		--cross-compiling

	export LD_LIBRARY_PATH=$TERMUX_PKG_HOSTBUILD_DIR/icu-installed/lib
	perl -p -i -e "s@LIBS := \\$\\(LIBS\\)@LIBS := -L$TERMUX_PKG_HOSTBUILD_DIR/icu-installed/lib -lpthread -licui18n -licuuc -licudata -ldl -lz@" \
		$TERMUX_PKG_SRCDIR/out/tools/v8_gypfiles/mksnapshot.host.mk \
		$TERMUX_PKG_SRCDIR/out/tools/v8_gypfiles/torque.host.mk \
		$TERMUX_PKG_SRCDIR/out/tools/v8_gypfiles/bytecode_builtins_list_generator.host.mk \
		$TERMUX_PKG_SRCDIR/out/tools/v8_gypfiles/v8_libbase.host.mk \
		$TERMUX_PKG_SRCDIR/out/tools/v8_gypfiles/gen-regexp-special-case.host.mk
}

termux_step_create_debscripts() {
	cat <<- EOF > ./postinst
	#!$TERMUX_PREFIX/bin/sh
	npm config set foreground-scripts true
	EOF
}
