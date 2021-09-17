TERMUX_PKG_HOMEPAGE=https://github.com/Macchina-CLI/macchina
TERMUX_PKG_DESCRIPTION="A system information fetcher, with an emphasis on performance and minimalism."
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Max Ferrer @PandaFoss"
TERMUX_PKG_VERSION=1.1.5
TERMUX_PKG_SRCURL=https://github.com/Macchina-CLI/macchina/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=e9b146dfdb13729bc760a9cc0954d85436f35a72e8d92b7bc476204fdb5e82d3
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_BLACKLISTED_ARCHES="arm, i686"

termux_step_make_install() {
	termux_setup_rust
	
	cargo build --jobs ${TERMUX_MAKE_PROCESSES} --target ${CARGO_TARGET_NAME} --release
	install -Dm755 -t ${TERMUX_PREFIX}/bin target/${CARGO_TARGET_NAME}/release/macchina
}
