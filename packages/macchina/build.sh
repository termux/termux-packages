TERMUX_PKG_HOMEPAGE=https://github.com/Macchina-CLI/macchina
TERMUX_PKG_DESCRIPTION="A system information fetcher, with an emphasis on performance and minimalism."
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.3.1"
TERMUX_PKG_SRCURL=git+https://github.com/Macchina-CLI/macchina
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_BLACKLISTED_ARCHES="arm, i686"

termux_step_make() {
	termux_setup_rust
	cargo build --jobs ${TERMUX_PKG_MAKE_PROCESSES} --target ${CARGO_TARGET_NAME} --release
}

termux_step_make_install() {
	install -Dm755 -t ${TERMUX_PREFIX}/bin target/${CARGO_TARGET_NAME}/release/macchina
}
