TERMUX_PKG_HOMEPAGE=https://github.com/vadimcn/codelldb
TERMUX_PKG_DESCRIPTION="A native debugger extension for VSCode based on LLDB"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.11.5"
TERMUX_PKG_SRCURL="https://github.com/vadimcn/codelldb/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=87ff4a444dbd0c6c9bcf1ac5527485355a400e9bee2386d7b0d33c70eeca188e
TERMUX_PKG_AUTO_UPDATE=true
# lldb does not support 32-bit
TERMUX_PKG_EXCLUDED_ARCHES="arm, i686"
TERMUX_PKG_DEPENDS="lldb"
TERMUX_CMAKE_BUILD="Unix Makefiles"
TERMUX_PKG_EXTRA_MAKE_ARGS="vsix_full"

termux_step_pre_configure() {
	termux_setup_nodejs
	termux_setup_rust

	# codelldb is a project that uses CMake in a slightly nonstandard way
	# (there is a place where the CMake build directory is hardcoded to
	# "[source directory]/build")
	# upstream only supports their official releases and not custom builds,
	# so this is not planned to be fixed upstream
	patch="$TERMUX_PKG_BUILDER_DIR/fix-tsconfig-cmake-builddir-path.diff"
	echo "Applying patch: $(basename "$patch")"
	test -f "$patch" && sed \
		-e "s%\@TERMUX_PKG_BUILDDIR\@%${TERMUX_PKG_BUILDDIR}%g" \
		"$patch" | patch --silent -p1 -d"$TERMUX_PKG_SRCDIR"

	case $TERMUX_ARCH in
		"aarch64") VSIX_ARCH="arm64";;
		"x86_64") VSIX_ARCH="x64";;
		*) termux_error_exit "${TERMUX_ARCH} is not a supported architecture."
	esac

	: "${CARGO_HOME:=$HOME/.cargo}"
	export CARGO_HOME
	rm -rf "$CARGO_HOME"/git/checkouts/weaklink-*

	cargo fetch --target "${CARGO_TARGET_NAME}"

	for dir in "$CARGO_HOME"/git/checkouts/weaklink-*/*; do
		patch --silent -p1 \
			-d "$dir" \
			< "$TERMUX_PKG_BUILDER_DIR"/weaklink-android.diff
	done

	# goes with CMakeLists.txt.patch
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DCARGO_TARGET_NAME=$CARGO_TARGET_NAME -DVSIX_PLATFORM=linux-$VSIX_ARCH"

	# avoids 'gyp: Undefined variable android_ndk_path in binding.gyp while trying to load binding.gyp'
	export GYP_DEFINES="android_ndk_path=''"
}

termux_step_make_install() {
	install -DTm644 "$TERMUX_PKG_BUILDDIR/codelldb-full.vsix" \
		"$TERMUX_PREFIX/opt/vsix-packages/codelldb-$TERMUX_PKG_FULLVERSION.vsix"

	# subpackage file
	install -DTm644 "$TERMUX_PKG_SRCDIR/LICENSE" \
		"$TERMUX_PREFIX/share/doc/code-oss-extension-codelldb/copyright"
}
