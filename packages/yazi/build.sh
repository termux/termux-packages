TERMUX_PKG_HOMEPAGE=https://yazi-rs.github.io/
TERMUX_PKG_DESCRIPTION="Blazing fast terminal file manager written in Rust, based on async I/O"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="25.4.8"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/sxyazi/yazi/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=b001df58df5276587eecb89ed90e8ea7a2bf738819ccb1afc722355fa2c56eae
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	termux_setup_rust
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

	# application icons
	local res
	for res in 16 24 32 48 64 128 256; do
		install -dm755 "${TERMUX_PREFIX}/share/icons/hicolor/${res}x${res}/apps"
		# `convert` is consolidated into the `magick` command on ImageMagick 7.0.0.0+
		# Ubuntu 24.04 ships version 6.9.12.98, we'll have to deal with this later.
		convert assets/logo.png -resize "${res}x${res}" "${TERMUX_PREFIX}/share/icons/hicolor/${res}x${res}/apps/yazi.png"
	done
}

termux_step_create_debscripts() {
	cat <<- POSTINST_EOF > ./postinst
	#!$TERMUX_PREFIX/bin/sh
	echo "Please change font from termux-styling addon"
	POSTINST_EOF
}
