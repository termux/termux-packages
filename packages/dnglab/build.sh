TERMUX_PKG_HOMEPAGE=https://github.com/dnglab/dnglab
TERMUX_PKG_DESCRIPTION="Camera RAW to DNG file format converter"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="Florian Wagner <florian@wagner-flo.de>"
TERMUX_PKG_VERSION="0.7.2"
TERMUX_PKG_SRCURL=https://github.com/dnglab/dnglab/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=c363a5ff8c058dd6d2ffe22a2ece986fa6ad146043f0211d9b77d789083901ce
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	termux_setup_rust
	cargo build --jobs $TERMUX_PKG_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release
}

termux_step_make_install() {
	install -Dm755 -t "${TERMUX_PREFIX}"/bin target/${CARGO_TARGET_NAME}/release/dnglab
	install -Dm644 bin/dnglab/completions/dnglab.bash "${TERMUX_PREFIX}/share/bash-completion/completions/dnglab"
}

termux_step_make_install() {
	install -Dm755 -t "${TERMUX_PREFIX}"/bin target/${CARGO_TARGET_NAME}/release/dnglab
	# Manpages
	install -Dm755 -t "${TERMUX_PREFIX}"/share/man/man1 bin/dnglab/manpages/*.1
	# Shell completions
	install -Dm644 bin/dnglab/completions/_dnglab "${TERMUX_PREFIX}/share/zsh/site-functions/_dnglab"
	install -Dm644 bin/dnglab/completions/dnglab.bash "${TERMUX_PREFIX}/share/bash-completion/completions/dnglab"
	install -Dm644 bin/dnglab/completions/dnglab.fish "${TERMUX_PREFIX}/share/fish/vendor_completions.d/dnglab.fish"
	install -Dm644 bin/dnglab/completions/dnglab.elv "${TERMUX_PREFIX}/share/elvish/lib/dnglab.elv"
}
