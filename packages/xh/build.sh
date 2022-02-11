TERMUX_PKG_HOMEPAGE=https://github.com/ducaale/xh
TERMUX_PKG_DESCRIPTION="A friendly and fast tool for sending HTTP requests"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.18.0
TERMUX_PKG_SRCURL=https://github.com/ducaale/xh/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=ed16781248d60a1f86d8da206440e9c761520bcd00917213dc6eb68fe357999e
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	termux_setup_rust
	cargo build --jobs $TERMUX_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/bin \
		target/${CARGO_TARGET_NAME}/release/xh
	ln -sf $TERMUX_PREFIX/bin/xh $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/bin/xhs

	mkdir -p "${TERMUX_PKG_MASSAGEDIR}/${TERMUX_PREFIX}"/share/man/man1
	mkdir -p "${TERMUX_PKG_MASSAGEDIR}/${TERMUX_PREFIX}"/share/bash-completion/completions
	mkdir -p "${TERMUX_PKG_MASSAGEDIR}/${TERMUX_PREFIX}"/share/zsh/site-functions
	mkdir -p "${TERMUX_PKG_MASSAGEDIR}/${TERMUX_PREFIX}"/share/fish/vendor_completions.d
	install -Dm600 -t "${TERMUX_PKG_MASSAGEDIR}/${TERMUX_PREFIX}"/share/man/man1/ doc/xh.1
	install -Dm644 -t "${TERMUX_PKG_MASSAGEDIR}/${TERMUX_PREFIX}"/share/bash-completion/completions/ completions/xh.bash
	install -Dm644 -t "${TERMUX_PKG_MASSAGEDIR}/${TERMUX_PREFIX}"/share/zsh/site-functions/ completions/_xh
	install -Dm644 -t "${TERMUX_PKG_MASSAGEDIR}/${TERMUX_PREFIX}"/share/fish/vendor_completions.d/ completions/xh.fish
}
