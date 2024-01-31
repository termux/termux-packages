TERMUX_PKG_HOMEPAGE=https://yazi-rs.github.io/
TERMUX_PKG_DESCRIPTION="Blazing fast terminal file manager written in Rust, based on async I/O"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.2.2"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/sxyazi/yazi/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=ce830fc312fc7a9515abefbbc71c8d1a46515257e9d1c56165cf6ff2fa5404c7
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_SUGGESTS="nerdfix"

termux_step_make() {
	termux_setup_rust
	YAZI_GEN_COMPLETIONS=true cargo build --jobs $TERMUX_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin target/${CARGO_TARGET_NAME}/release/yazi

	install -Dm644 yazi-config/completions/"${TERMUX_PKG_NAME}".bash \
		"${TERMUX_PREFIX}"/share/bash-completion/completions/"${TERMUX_PKG_NAME}".bash
	install -Dm644 yazi-config/completions/_"${TERMUX_PKG_NAME}" \
		"${TERMUX_PREFIX}"/share/zsh/site-functions/_"${TERMUX_PKG_NAME}"
	install -Dm644 yazi-config/completions/"${TERMUX_PKG_NAME}".fish \
		"${TERMUX_PREFIX}"/share/fish/vendor_completions.d/"${TERMUX_PKG_NAME}".fish
}

termux_step_create_debscripts() {
	cat <<- POSTINST_EOF > ./postinst
	#!$TERMUX_PREFIX/bin/sh
	echo "Use of a NerdFont is recommended for yazi."
	echo "You can either select one from the Termux:Styling add-on"
	echo "or manually install a NerdFont of your choice from:"
	echo "https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts"
	echo "and replacing ~/.termux/font.ttf with it"
	POSTINST_EOF
}
