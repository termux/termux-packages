TERMUX_PKG_HOMEPAGE=https://github.com/dnglab/dnglab
TERMUX_PKG_DESCRIPTION="Camera RAW to DNG file format converter"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_LICENSE_FILE="LICENSE"
TERMUX_PKG_MAINTAINER="Florian Wagner <florian@wagner-flo.de>"
TERMUX_PKG_VERSION="0.7.0"
TERMUX_PKG_SRCURL=https://github.com/dnglab/dnglab/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=dffe4dd94913a687184b2a453eeb170c87afbca62ecf3a4bc680e5f5bf22cacc
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
