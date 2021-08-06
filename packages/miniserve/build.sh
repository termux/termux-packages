TERMUX_PKG_HOMEPAGE=https://github.com/svenstaro/miniserve
TERMUX_PKG_DESCRIPTION="Tool to serve files via HTTP"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.14.0
TERMUX_PKG_SRCURL=https://github.com/svenstaro/miniserve/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=68e21c35a4577251f656f3d1ccac2de23abd68432810b11556bcc8976bb19fc5
TERMUX_PKG_DEPENDS=libbz2
TERMUX_PKG_BUILD_IN_SRC=true
termux_step_pre_configure() {
	rm -f Makefile
	termux_setup_rust
}
termux_step_make() {
	cargo build --jobs $TERMUX_MAKE_PROCESSES --target $CARGO_TARGET_NAME \
		--release --locked
	cargo test --release --locked -- --test-threads=1
}
termux_step_make_install() {
	install -Dm755 -t "$TERMUX_PREFIX"/bin/miniserve \
		target/${CARGO_TARGET_NAME}/release/miniserve
}
termux_step_post_make_install() {
	mkdir -p "$TERMUX_PREFIX"/share/{bash-completion/completions,zsh/site-functions,fish/vendor_completions.d}
	target/${CARGO_TARGET_NAME}/release/miniserve --print-completions bash \
		> "$TERMUX_PREFIX"/share/bash-completion/completions/miniserve
	target/${CARGO_TARGET_NAME}/release/miniserve --print-completions zsh \
		> "$TERMUX_PREFIX"/share/zsh/site-functions/_miniserve
	target/${CARGO_TARGET_NAME}/release/miniserve --print-completions fish \
		> "$TERMUX_PREFIX"/share/fish/vendor_completions.d/miniserve.fish

	echo -e "\e[1;33mWARNING:\e[0m" \
		"miniserve follows symlinks in selected directory by default." \
		"Consider aliasing it with '--no-symlinks' for safety." \
		"Refer: https://github.com/svenstaro/miniserve/issues/498"
}
termux_step_install_license() {
	install -Dm644 LICENSE "$TERMUX_PREFIX"/share/licenses/miniserve/LICENSE
}
