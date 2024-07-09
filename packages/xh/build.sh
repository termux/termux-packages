TERMUX_PKG_HOMEPAGE=https://github.com/ducaale/xh
TERMUX_PKG_DESCRIPTION="A friendly and fast tool for sending HTTP requests"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.22.2"
TERMUX_PKG_SRCURL=https://github.com/ducaale/xh/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=32a6470ab705aba4c37fce9806202dcc0ed24f55e091e2f4bdf7583108a3da63
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	termux_setup_rust
	cargo build --jobs $TERMUX_PKG_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin target/${CARGO_TARGET_NAME}/release/xh
	ln -sf $TERMUX_PREFIX/bin/xh{,s}

	install -Dm600 doc/xh.1 "${TERMUX_PREFIX}"/share/man/man1/xh.1
	install -Dm644 completions/xh.bash "${TERMUX_PREFIX}"/share/bash-completion/completions/xh.bash
	install -Dm644 completions/_xh "${TERMUX_PREFIX}"/share/zsh/site-functions/_xh
	install -Dm644 completions/xh.fish "${TERMUX_PREFIX}"/share/fish/vendor_completions.d/xh.fish
}
