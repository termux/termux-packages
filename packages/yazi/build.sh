TERMUX_PKG_HOMEPAGE=https://yazi-rs.github.io/
TERMUX_PKG_DESCRIPTION="Blazing fast terminal file manager written in Rust, based on async I/O"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="25.5.31"
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/sxyazi/yazi/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=4d005e7c3f32b5574d51ab105597f3da3a4be2f7b5cd1bcb284143ad38253ed4
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_ICONS="assets/logo.png"
TERMUX_PKG_ICON_NAMES="yazi"

termux_step_pre_configure() {
	termux_setup_rust
	# Fix for `TERMUX_ON_DEVICE_BUILD=true` builds
	# To prevent `ld.lld: error: unable to find library -lgcc`
	# Should have been fixed in Rust 1.54.0 (https://github.com/rust-lang/rust/pull/85806)
	# But still seems to occur.
	echo "INPUT(-lunwind)" > "${TERMUX_PKG_BUILDDIR}/libgcc.a"
	local -u env_host="${CARGO_TARGET_NAME//-/_}"
	export CARGO_TARGET_"${env_host}"_RUSTFLAGS+=" -L ${TERMUX_PKG_BUILDDIR}"
}

termux_step_make() {
	VERGEN_GIT_SHA="termux" \
	YAZI_GEN_COMPLETIONS=true \
	cargo build --jobs "$TERMUX_PKG_MAKE_PROCESSES" --target "$CARGO_TARGET_NAME" --release
}

termux_step_make_install() {
	install -Dm700 -t "$TERMUX_PREFIX/bin" "target/${CARGO_TARGET_NAME}/release/yazi"
	install -Dm700 -t "$TERMUX_PREFIX/bin" "target/${CARGO_TARGET_NAME}/release/ya"

	# shell completions
	install -Dm644 yazi-boot/completions/yazi.bash "$TERMUX_PREFIX/share/bash-completion/completions/yazi.bash"
	install -Dm644 yazi-boot/completions/yazi.elv  "$TERMUX_PREFIX/share/elvish/lib/yazi.elv"
	install -Dm644 yazi-boot/completions/yazi.fish "$TERMUX_PREFIX/share/fish/vendor_completions.d/yazi.fish"
	install -Dm644 yazi-boot/completions/yazi.nu   "$TERMUX_PREFIX/share/nushell/vendor/autoload/yazi.nu"
	install -Dm644 yazi-boot/completions/_yazi     "$TERMUX_PREFIX/share/zsh/site-functions/_yazi"

	# desktop entry
	install -Dm644 assets/yazi.desktop "$TERMUX_PREFIX/share/applications/yazi.desktop"
}

termux_step_create_debscripts() {
	cat <<- POSTINST_EOF > ./postinst
	#!$TERMUX_PREFIX/bin/sh
	echo "Please change font from termux-styling addon"
	POSTINST_EOF
}
