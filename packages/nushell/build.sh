TERMUX_PKG_HOMEPAGE=https://www.nushell.sh
TERMUX_PKG_DESCRIPTION="A new type of shell operating on structured data"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.116.0"
TERMUX_PKG_SRCURL=https://github.com/nushell/nushell/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=1174d023ffc8083750daec8ee2dfe6486a8ef9f5c22396aa675b61d1bb0fad2d
TERMUX_PKG_DEPENDS="openssl"
TERMUX_PKG_RECOMMENDS="command-not-found, termux-api"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	termux_setup_rust

	if [ "$TERMUX_ARCH" = "x86_64" ]; then
		local env_host=$(printf $CARGO_TARGET_NAME | tr a-z A-Z | sed s/-/_/g)
		export CARGO_TARGET_${env_host}_RUSTFLAGS+=" -C link-arg=$($CC -print-libgcc-file-name)"
	fi
}

termux_step_post_make_install() {
	local autoload_dir="$TERMUX_PREFIX/share/nushell/vendor/autoload"
	mkdir -p "$autoload_dir"
	sed "s|@TERMUX_PREFIX@|$TERMUX_PREFIX|" "$TERMUX_PKG_BUILDER_DIR/command-not-found.nu" \
		>"$autoload_dir/command-not-found.nu"
}
