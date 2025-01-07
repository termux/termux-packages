TERMUX_PKG_HOMEPAGE=https://github.com/doy/rbw
TERMUX_PKG_DESCRIPTION="An unofficial command line client for Bitwarden"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.13.2"
TERMUX_PKG_SRCURL=https://github.com/doy/rbw/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=afe8887b64c4da6e5f33535d02ad4e1fe75c536a55d63291622b4b339522d138
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="pinentry"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	termux_setup_rust

	cargo build \
		--jobs "$TERMUX_PKG_MAKE_PROCESSES" \
		--target "$CARGO_TARGET_NAME" \
		--no-default-features \
		--release
}

termux_step_make_install() {
	install -Dm755 -t $TERMUX_PREFIX/bin $TERMUX_PKG_SRCDIR/target/${CARGO_TARGET_NAME}/release/rbw
	install -Dm755 -t $TERMUX_PREFIX/bin $TERMUX_PKG_SRCDIR/target/${CARGO_TARGET_NAME}/release/rbw-agent

	install -Dm644 /dev/null "${TERMUX_PREFIX}/share/bash-completion/completions/rbw.bash"
	install -Dm644 /dev/null "${TERMUX_PREFIX}/share/zsh/site-functions/_rbw"
	install -Dm644 /dev/null "${TERMUX_PREFIX}/share/fish/vendor_completions.d/rbw.fish"
	install -Dm644 /dev/null "${TERMUX_PREFIX}/share/elvish/lib/rbw.elv"
}

termux_step_create_debscripts() {
	cat <<-EOF >./postinst
		#!${TERMUX_PREFIX}/bin/sh
		rbw gen-completions bash > ${TERMUX_PREFIX}/share/bash-completion/completions/rbw.bash
		rbw gen-completions zsh > ${TERMUX_PREFIX}/share/zsh/site-functions/_rbw
		rbw gen-completions fish > ${TERMUX_PREFIX}/share/fish/vendor_completions.d/rbw.fish
		rbw gen-completions elvish > ${TERMUX_PREFIX}/share/elvish/lib/rbw.elv
	EOF
}
