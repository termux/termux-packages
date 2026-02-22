TERMUX_PKG_HOMEPAGE=https://github.com/trentbuck/binutils-is-llvm
TERMUX_PKG_DESCRIPTION="Use llvm as binutils"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
# The version number is different from the original one.
TERMUX_PKG_VERSION=0.3
TERMUX_PKG_REVISION=4
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_SKIP_SRC_EXTRACT=true
TERMUX_PKG_DEPENDS="lld, llvm"
TERMUX_PKG_CONFLICTS="binutils"

termux_step_make_install() {
	ln -sf lld "$TERMUX_PREFIX/bin/ld"
	local bin
	# Please do not include `as`. `llvm-as` is pretty different from GNU as.
	# Clang's `-fno-integrated-as` will not work as expected when `as` is a symlink to `llvm-as`.
	# `bin/as` is provided by the `binutils-bin` subpackage which does not collide with this package.
	local -a _UTILS=("addr2line" "ar" "nm" "objcopy" "objdump" "ranlib" "readelf" "size" "strings" "strip")
	for bin in "${_UTILS[@]}"; do
		ln -sf "llvm-${bin}" "$TERMUX_PREFIX/bin/${bin}"
	done
	ln -sf llvm-cxxfilt "$TERMUX_PREFIX/bin/c++filt"

	local dir=$TERMUX_PREFIX/share/$TERMUX_PKG_NAME
	mkdir -p "$dir"
	touch "$dir/.placeholder"

	# Add some arch-prefixed symlinks like binutils.
	local -a _UTILS_WITH_HOST_PREFIX=("ar" "ld" "nm" "objdump" "ranlib" "readelf" "strip")
	for bin in "${_UTILS_WITH_HOST_PREFIX[@]}"; do
		ln -sf "$bin" "$TERMUX_PREFIX/bin/$TERMUX_HOST_PLATFORM-$bin"
	done
}

termux_step_install_license() {
	install -Dm600 -t "$TERMUX_PREFIX/share/doc/$TERMUX_PKG_NAME" \
		"$TERMUX_PKG_BUILDER_DIR/LICENSE"
}
