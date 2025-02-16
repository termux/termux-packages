TERMUX_PKG_HOMEPAGE=https://yazi-rs.github.io/
TERMUX_PKG_DESCRIPTION="Blazing fast terminal file manager written in Rust, based on async I/O"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="25.2.11"
TERMUX_PKG_SRCURL=https://github.com/sxyazi/yazi/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=d3879b85465e036abfd69c53488e9bc90c9ad52a31080511a0fcd1b11f81f10b
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

	cd yazi-boot/completions
	install -Dm644 "${TERMUX_PKG_NAME}.bash" "${TERMUX_PREFIX}/share/bash-completion/completions/${TERMUX_PKG_NAME}.bash"
	install -Dm644 "${TERMUX_PKG_NAME}.elv"  "${TERMUX_PREFIX}/share/elvish/lib/${TERMUX_PKG_NAME}.elv"
	install -Dm644 "${TERMUX_PKG_NAME}.fish" "${TERMUX_PREFIX}/share/fish/vendor_completions.d/${TERMUX_PKG_NAME}.fish"
	install -Dm644 "${TERMUX_PKG_NAME}.nu"   "${TERMUX_PREFIX}/share/nushell/vendor/autoload/${TERMUX_PKG_NAME}.nu"
	install -Dm644 "_${TERMUX_PKG_NAME}"     "${TERMUX_PREFIX}/share/zsh/site-functions/_${TERMUX_PKG_NAME}"
}

termux_step_create_debscripts() {
	cat <<- POSTINST_EOF > ./postinst
	#!$TERMUX_PREFIX/bin/sh
	echo "Please change font from termux-styling addon"
	POSTINST_EOF
}
