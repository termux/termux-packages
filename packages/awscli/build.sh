TERMUX_PKG_HOMEPAGE=https://aws.amazon.com/cli
TERMUX_PKG_DESCRIPTION="Universal Command Line Interface for Amazon Web Services"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.33.19"
TERMUX_PKG_SRCURL="https://github.com/aws/aws-cli/archive/refs/tags/$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=980714d606a0ee4a3aa42defee20f143f51b64200bc62f71e53716086ec344cf
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+.\d+.\d+"
TERMUX_PKG_DEPENDS="libandroid-posix-semaphore, libandroid-support, libbz2, libexpat, libffi, liblzma, libsqlite, mandoc, openssl, readline, zlib"
TERMUX_PKG_SUGGESTS="groff"
TERMUX_PKG_BUILD_DEPENDS="aosp-libs, python-pip, cmake, ldd"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--with-install-type=portable-exe
--with-download-deps
PYTHON=$TERMUX_PREFIX/bin/python
"

termux_step_pre_configure() {
	export LDFLAGS+=" -lm"
	export PIP_NO_BINARY=awscrt
	export AWS_CRT_BUILD_FORCE_STATIC_LIBS=1

	if [[ "$TERMUX_ON_DEVICE_BUILD" == "true" ]]; then
		return
	fi

	local PYTHON_INCLUDE="$TERMUX_PREFIX/include/python$TERMUX_PYTHON_VERSION"

	TERMUX_PROOT_EXTRA_ENV_VARS=" \
	LD_PRELOAD= LD_LIBRARY_PATH= \
	PIP_NO_BINARY=$PIP_NO_BINARY \
	AWS_CRT_BUILD_FORCE_STATIC_LIBS=$AWS_CRT_BUILD_FORCE_STATIC_LIBS \
	PIP_NO_INDEX=1 \
	CC=$CC \
	CXX=$CXX \
	AR=$AR \
	RANLIB=$RANLIB \
	CFLAGS='$CFLAGS -I$PYTHON_INCLUDE' \
	CPPFLAGS='$CPPFLAGS -I$PYTHON_INCLUDE' \
	CXXFLAGS='$CXXFLAGS' \
	LDFLAGS='$LDFLAGS' \
	"
}

termux_step_configure() {
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "true" ]]; then
		termux_step_configure_autotools
		return
	fi

	termux_setup_proot

	termux-proot-run "$TERMUX_PKG_SRCDIR/configure" \
		--prefix="$TERMUX_PREFIX" \
		$TERMUX_PKG_EXTRA_CONFIGURE_ARGS
}

termux_step_make() {
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "true" ]]; then
		make
		return
	fi

	local WHEELHOUSE="$TERMUX_PKG_BUILDDIR/wheelhouse"
	mkdir -p "$WHEELHOUSE"

	python3 -m pip download \
		--dest "$WHEELHOUSE" \
		--platform "linux_$TERMUX_ARCH" \
		--python-version "$TERMUX_PYTHON_VERSION" \
		--implementation cp \
		--abi cp"${TERMUX_PYTHON_VERSION//.}" \
		--abi abi3 \
		--abi none \
		--no-deps \
		-r "$TERMUX_PKG_SRCDIR/requirements/download-deps/bootstrap-lock.txt" \
		-r "$TERMUX_PKG_SRCDIR/requirements/download-deps/portable-exe-lock.txt"

	termux-proot-run \
		-b "$TERMUX_STANDALONE_TOOLCHAIN/sysroot/usr/include/android:$TERMUX__PREFIX__INCLUDE_DIR/android" \
		env PIP_FIND_LINKS="file://$WHEELHOUSE" \
		make
}

termux_step_make_install() {
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "true" ]]; then
		make install
		return
	fi

	termux-proot-run make install
}
