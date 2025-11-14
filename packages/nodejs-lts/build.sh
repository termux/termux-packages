TERMUX_PKG_HOMEPAGE=https://nodejs.org/
TERMUX_PKG_DESCRIPTION="Open Source, cross-platform JavaScript runtime environment"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Yaksh Bariya <thunder-coding@termux.dev>"
# Also update version in termux_setup_nodejs.sh when updating this package
TERMUX_PKG_VERSION=22.20.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://nodejs.org/dist/v${TERMUX_PKG_VERSION}/node-v${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=ff7a6a6e8a1312af5875e40058351c4f890d28ab64c32f12b2cc199afa22002d
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
	######
	# Do host-build of ICU, which is required for nodejs
	######
	local ICU_VERSION=76.1
	local ICU_TAR=icu4c-${ICU_VERSION//./_}-src.tgz
	local ICU_DOWNLOAD=https://github.com/unicode-org/icu/releases/download/release-${ICU_VERSION//./-}/$ICU_TAR
	export CC="$TERMUX_HOST_LLVM_BASE_DIR/bin/clang"
	export CXX="$TERMUX_HOST_LLVM_BASE_DIR/bin/clang++"
	export LD="$TERMUX_HOST_LLVM_BASE_DIR/bin/clang++"
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

	######
	# Download LLVM toolchain used by the upstream v8 project.
	# Upstream v8 uses LLVM tooling from the main branch of the LLVM project as
	# the main branch often contains bug fixes which are not released quickly to
	# stable releases. Also Ubuntu's LLVM toolchain is too old in comparison to
	# what Google uses.
	######

	# Instructions to find the LLVM_COMMIT and LLVM_TAR_HASH used by the v8
	# version in nodejs:
	#
	# Look into the deps/v8/DEPS file, and look for the 'tools/clang' entry.
	#  'tools/clang':
	#    Var('chromium_url') + '/chromium/src/tools/clang.git' + '@' + '6c4f037a983abf14a4c8bf00e44db73cdf330a97',
	#
	# You can now choose to either choose to do a full checkout of the v8 commit
	# and do `gclient sync` to get the full tree, or just peek at
	# https://chromium.googlesource.com/chromium/src/tools/clang.git/+/6c4f037a983abf14a4c8bf00e44db73cdf330a97/scripts/update.py
	# Look at the CLANG_REVISION and CLANG_SUB_REVISION variable,
	# LLVM_TAR="${CLANG_REVISION}-${CLANG_SUB_REVISION}.tar.xz"
	#
	# From scripts/update.py
	# 39 | CLANG_REVISION = 'llvmorg-21-init-9266-g09006611'
	# 40 | CLANG_SUB_REVISION = 1
	#
	# then the LLVM_COMMIT is 09006611.
	# LLVM_TAR_HASH is not available in the DEPS file, so you need to do a
	# download yourself to find it
	#
	# NOTE: If you are not able to find the LLVM_COMMIT according to the above instructions,
	#       this is because of https://chromium.googlesource.com/v8/v8.git/+/e5ffb0f66d122129a04cf1f4ffcf6a6e3b956ee0
	#       nodejs-lts comes with an older version of v8 which does not have this patch.
	#       Updated instructions can be found in the build.sh file for nodejs package
	local LLVM_TAR="clang-llvmorg-21-init-9266-g09006611-1.tar.xz"
	local LLVM_TAR_HASH=2cccd3a5b04461f17a2e78d2f8bd18b448443a9dd4d6dfac50e8e84b4d5176f1
	cd $TERMUX_PKG_HOSTBUILD_DIR
	mkdir llvm-project-build
	termux_download \
			"https://commondatastorage.googleapis.com/chromium-browser-clang/Linux_x64/${LLVM_TAR}" \
			"${TERMUX_PKG_CACHEDIR}/${LLVM_TAR}" \
			"${LLVM_TAR_HASH}"
	tar --extract -f "${TERMUX_PKG_CACHEDIR}/${LLVM_TAR}" --directory=llvm-project-build
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

	# Do not enable by default as it has severe performance degradations.
	# Causes upto 10x performance degradations
	#
	# V8 uses a lot of inlining for optimization results.
	# Although those optimizations are very much desired, during debugging it can
	# cause problems as it prevents debuggers from hooking in properly at all code
	# paths
	#
	# if [ "${TERMUX_DEBUG_BUILD}" = "true" ]; then
	# 	CFLAGS+=" -fno-inline"
	# 	CXXFLAGS+=" -fno-inline"
	# fi

	export GYP_DEFINES="host_os=linux"
	if [ "$TERMUX_ARCH_BITS" = "64" ]; then
		export CC_host="$TERMUX_PKG_HOSTBUILD_DIR/llvm-project-build/bin/clang"
		export CXX_host="$TERMUX_PKG_HOSTBUILD_DIR/llvm-project-build/bin/clang++"
		export LINK_host="$TERMUX_PKG_HOSTBUILD_DIR/llvm-project-build/bin/clang++"
	else
		export CC_host="$TERMUX_PKG_HOSTBUILD_DIR/llvm-project-build/bin/clang -m32"
		export CXX_host="$TERMUX_PKG_HOSTBUILD_DIR/llvm-project-build/bin/clang++ -m32"
		export LINK_host="$TERMUX_PKG_HOSTBUILD_DIR/llvm-project-build/bin/clang++ -m32"
	fi

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
		-e "s|\-L$TERMUX_PREFIX/$TERMUX_PREFIX/lib||g" \
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
