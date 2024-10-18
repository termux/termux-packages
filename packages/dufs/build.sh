TERMUX_PKG_HOMEPAGE=https://github.com/sigoden/dufs
TERMUX_PKG_DESCRIPTION="A file server that supports static serving, uploading, searching, accessing control, webdav..."
TERMUX_PKG_LICENSE="Apache-2.0,MIT"
TERMUX_PKG_LICENSE_FILE="LICENSE-APACHE,LICENSE-MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.42.0"
TERMUX_PKG_SRCURL=https://github.com/sigoden/dufs/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=76439a01c142d6a378912930de4b74821aa2fef54ccfb7dbb00d6ea3b1a0ab4c
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	termux_setup_rust
	cargo build --jobs $TERMUX_PKG_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release
}

termux_step_post_make_install() {
	install -Dm755 -t $TERMUX_PREFIX/bin target/${CARGO_TARGET_NAME}/release/dufs

	install -Dm644 /dev/null "$TERMUX_PREFIX"/share/bash-completion/completions/dufs
	install -Dm644 /dev/null "$TERMUX_PREFIX"/share/zsh/site-functions/_dufs
	install -Dm644 /dev/null "$TERMUX_PREFIX"/share/fish/vendor_completions.d/dufs.fish
}

termux_step_create_debscripts() {
	cat <<- EOF > ./postinst
	#!$TERMUX_PREFIX/bin/sh

	dufs --completions bash \
		> "$TERMUX_PREFIX"/share/bash-completion/completions/dufs
	dufs --completions zsh \
		> "$TERMUX_PREFIX"/share/zsh/site-functions/_dufs
	dufs --completions fish \
		> "$TERMUX_PREFIX"/share/fish/vendor_completions.d/dufs.fish
	EOF
}
