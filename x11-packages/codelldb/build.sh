TERMUX_PKG_HOMEPAGE=https://github.com/vadimcn/codelldb
TERMUX_PKG_DESCRIPTION="A native debugger extension for VSCode based on LLDB"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.12.1"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL="https://github.com/vadimcn/codelldb/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=5d6dbf96ca5b030a2f011de84148953d8527eaba5d38cb16e56d68905b9a2f67
TERMUX_PKG_AUTO_UPDATE=true
# codelldb does not work properly on 32-bit Android
TERMUX_PKG_EXCLUDED_ARCHES="arm, i686"
TERMUX_PKG_DEPENDS="lldb"
TERMUX_PKG_CMAKE_BUILD="Unix Makefiles"
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

	patch="$TERMUX_PKG_BUILDER_DIR/move-adapter-outside-vsix.diff"
	echo "Applying patch: $(basename "$patch")"
	test -f "$patch" && sed \
		-e "s%\@TERMUX_PREFIX\@%${TERMUX_PREFIX}%g" \
		-e "s%\@TERMUX_PYTHON_HOME\@%${TERMUX_PYTHON_HOME}%g" \
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
	# adapter binary and launcher binary for main package
	install -Dm700 -t "$TERMUX_PREFIX/bin" "$TERMUX_PKG_BUILDDIR/adapter/codelldb"
	install -Dm700 -t "$TERMUX_PREFIX/bin" "$TERMUX_PKG_BUILDDIR/bin/codelldb-launch"

	# python module for main package
	local codelldb_python_dest="$TERMUX_PYTHON_HOME/site-packages/codelldb/"
	rm -rf "$codelldb_python_dest"
	mkdir -p "$codelldb_python_dest"
	cp -r "$TERMUX_PKG_BUILDDIR"/adapter/scripts/codelldb/* "$codelldb_python_dest"
	install -Dm644 -t "$codelldb_python_dest" "$TERMUX_PKG_BUILDDIR/adapter/scripts/debugger.py"

	# .vsix file for vsix-package-codelldb
	install -DTm644 "$TERMUX_PKG_BUILDDIR/codelldb-full.vsix" \
		"$TERMUX_PREFIX/opt/vsix-packages/codelldb-$TERMUX_PKG_FULLVERSION.vsix"

	# subpackage file for code-oss-extension-codelldb
	install -DTm644 "$TERMUX_PKG_SRCDIR/LICENSE" \
		"$TERMUX_PREFIX/share/doc/code-oss-extension-codelldb/copyright"
}
