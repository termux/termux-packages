TERMUX_PKG_HOMEPAGE=https://nodejs.org/
TERMUX_PKG_DESCRIPTION="Open Source, cross-platform JavaScript runtime environment"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Yaksh Bariya <thunder-coding@termux.dev>"
TERMUX_PKG_VERSION=20.17.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://nodejs.org/dist/v${TERMUX_PKG_VERSION}/node-v${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=9abf03ac23362c60387ebb633a516303637145cb3c177be3348b16880fd8b28c
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
TERMUX_PKG_HOSTBUILD=true

termux_step_post_get_source() {
	# Prevent caching of host build:
	rm -Rf $TERMUX_PKG_HOSTBUILD_DIR
}

termux_step_pre_configure() {
	termux_setup_ninja
}

termux_step_host_build() {
	local ICU_VERSION=76.1
	local ICU_TAR=icu4c-${ICU_VERSION//./_}-src.tgz
	local ICU_DOWNLOAD=https://github.com/unicode-org/icu/releases/download/release-${ICU_VERSION//./-}/$ICU_TAR
	termux_download \
		$ICU_DOWNLOAD\
		$TERMUX_PKG_CACHEDIR/$ICU_TAR \
		dfacb46bfe4747410472ce3e1144bf28a102feeaa4e3875bac9b4c6cf30f4f3e
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
	make -j $TERMUX_PKG_MAKE_PROCESSES install
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

	export LD_LIBRARY_PATH=$TERMUX_PKG_HOSTBUILD_DIR/icu-installed/lib
	sed -i \
		-e "s|\-I$TERMUX_PREFIX/include||g" \
		-e "s|\-L$TERMUX_PREFIX/lib||g" \
		-e "s|-licui18n||g" \
		-e "s|-licuuc||g" \
		-e "s|-licudata||g" \
		$TERMUX_PKG_SRCDIR/out/{Release,Debug}/obj.host/node_js2c.ninja
	sed -i \
		-e "s|\-I$TERMUX_PREFIX/include|-I$TERMUX_PKG_HOSTBUILD_DIR/icu-installed/include|g" \
		-e "s|\-L$TERMUX_PREFIX/lib|-L$TERMUX_PKG_HOSTBUILD_DIR/icu-installed/lib|g" \
		$(find $TERMUX_PKG_SRCDIR/out/{Release,Debug}/obj.host -name '*.ninja')

}

termux_step_make() {
	if [ "${TERMUX_DEBUG_BUILD}" = "true" ]; then
		ninja -C out/Debug -j "${TERMUX_PKG_MAKE_PROCESSES}"
	else
		ninja -C out/Release -j "${TERMUX_PKG_MAKE_PROCESSES}"
	fi
}

termux_step_make_install() {
	local _BUILD_DIR=out/
	if [ "${TERMUX_DEBUG_BUILD}" = "true" ]; then
		_BUILD_DIR+="/Debug/"
	else
		_BUILD_DIR+="/Release/"
	fi
	python tools/install.py install --dest-dir="" --prefix "${TERMUX_PREFIX}" --build-dir "$_BUILD_DIR"
}

termux_step_create_debscripts() {
	cat <<- EOF > ./postinst
	#!$TERMUX_PREFIX/bin/sh
	npm config set foreground-scripts true
	EOF
}
