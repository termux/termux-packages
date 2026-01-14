TERMUX_PKG_HOMEPAGE=http://x265.org/
TERMUX_PKG_DESCRIPTION="H.265/HEVC video stream encoder library"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.1"
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://bitbucket.org/multicoreware/x265_git/downloads/x265_${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=a31699c6a89806b74b0151e5e6a7df65de4b49050482fe5ebf8a4379d7af8f29
TERMUX_PKG_DEPENDS="libandroid-posix-semaphore, libc++"
TERMUX_PKG_BREAKS="libx265-dev"
TERMUX_PKG_REPLACES="libx265-dev"

termux_step_pre_configure() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION=215

	local v=$(sed -En 's/^.*set\(X265_BUILD ([0-9]+).*$/\1/p' \
			source/CMakeLists.txt)
	if [ "${v}" != "${_SOVERSION}" ]; then
		termux_error_exit "SOVERSION guard check failed."
	fi

	local _TERMUX_CLANG_TARGET=

	# Not sure if this is necessary for on-device build
	# Follow termux_step_configure_cmake.sh for now
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "false" ]]; then
		_TERMUX_CLANG_TARGET="--target=${CCTERMUX_HOST_PLATFORM}"
	fi

	if [[ "$TERMUX_ARCH" = arm || "$TERMUX_ARCH" = i686 ]]; then
		# Avoid text relocations and/or build failure.
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DENABLE_ASSEMBLY=OFF"
	fi

	TERMUX_PKG_SRCDIR="$TERMUX_PKG_SRCDIR/source"

	sed -i "s/@TERMUX_CLANG_TARGET_${TERMUX_ARCH^^}@/${_TERMUX_CLANG_TARGET}/" \
		${TERMUX_PKG_SRCDIR}/CMakeLists.txt

	LDFLAGS+=" -landroid-posix-semaphore"
}

termux_step_configure() {
	termux_setup_cmake
	termux_setup_ninja

	if [[ "$TERMUX_ARCH_BITS" == "32" ]]; then
		pushd "$TERMUX_PKG_BUILDDIR"
		termux_step_configure_cmake
		popd
		return
	fi

	# build multiple bit depth modes into a single library by copying how Arch Linux does it
	# https://gitlab.archlinux.org/archlinux/packaging/packages/x265/-/blob/3761f9fb296071fc81dc1c74861fb9f6a94aa8ba/PKGBUILD#L49
	# note: -DHIGH_BIT_DEPTH=ON and -DMAIN12=ON have no effect on 32-bit targets
	# https://bitbucket.org/multicoreware/x265_git/src/9e551a994f970a24f0e49bcebe3d43ef08448b01/source/CMakeLists.txt#lines-690
	local original_options=(
	"$TERMUX_PKG_EXTRA_CONFIGURE_ARGS"
	-DENABLE_HDR10_PLUS=ON
	-DCMAKE_POLICY_VERSION_MINIMUM=3.5
	)
	local tenbit_options=(
	"${original_options[@]}"
	-DENABLE_CLI=OFF
	-DENABLE_SHARED=OFF
	-DEXPORT_C_API=OFF
	-DHIGH_BIT_DEPTH=ON
	)
	local twelvebit_options=(
	"${tenbit_options[@]}"
	-DMAIN12=ON
	)
	local final_options=(
	"${original_options[@]}"
	-DENABLE_SHARED=ON
	-DEXTRA_LIB='x265_main10.a;x265_main12.a'
	-DEXTRA_LINK_FLAGS="-L$TERMUX_PKG_BUILDDIR"
	-DLINKED_10BIT=ON
	-DLINKED_12BIT=ON
	)

	TERMUX_PKG_EXTRA_CONFIGURE_ARGS="${tenbit_options[@]}"
	mkdir -p "$TERMUX_PKG_BUILDDIR/10bit_build"
	pushd "$TERMUX_PKG_BUILDDIR/10bit_build"
	termux_step_configure_cmake
	popd

	TERMUX_PKG_EXTRA_CONFIGURE_ARGS="${twelvebit_options[@]}"
	mkdir -p "$TERMUX_PKG_BUILDDIR/12bit_build"
	pushd "$TERMUX_PKG_BUILDDIR/12bit_build"
	termux_step_configure_cmake
	popd

	TERMUX_PKG_EXTRA_CONFIGURE_ARGS="${final_options[@]}"
	pushd "$TERMUX_PKG_BUILDDIR"
	termux_step_configure_cmake
	popd
}

termux_step_make() {
	if [[ "$TERMUX_ARCH_BITS" == "32" ]]; then
		cmake --build "$TERMUX_PKG_BUILDDIR"
		return
	fi

	cmake --build "$TERMUX_PKG_BUILDDIR/10bit_build"
	cmake --build "$TERMUX_PKG_BUILDDIR/12bit_build"
	ln -sfr "$TERMUX_PKG_BUILDDIR/10bit_build/libx265.a" "$TERMUX_PKG_BUILDDIR/libx265_main10.a"
	ln -sfr "$TERMUX_PKG_BUILDDIR/12bit_build/libx265.a" "$TERMUX_PKG_BUILDDIR/libx265_main12.a"
	cmake --build "$TERMUX_PKG_BUILDDIR"
}

termux_step_post_massage() {
	local _GUARD_FILE="lib/${TERMUX_PKG_NAME}.so"
	if [ ! -e "${_GUARD_FILE}" ]; then
		termux_error_exit "file ${_GUARD_FILE} not found."
	fi
}
