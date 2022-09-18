TERMUX_PKG_HOMEPAGE=https://github.com/Macchina-CLI/macchina
TERMUX_PKG_DESCRIPTION="A system information fetcher, with an emphasis on performance and minimalism."
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Max Ferrer @PandaFoss"
TERMUX_PKG_VERSION="6.1.5"
TERMUX_PKG_SRCURL=https://github.com/Macchina-CLI/macchina/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=0df28be92649746ebe4dec13c1a4f95e877cea2ece8ee463e836c0004555248d
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_BLACKLISTED_ARCHES="arm, i686"

termux_step_make_install() {
	termux_setup_rust
	
	cargo build --jobs ${TERMUX_MAKE_PROCESSES} --target ${CARGO_TARGET_NAME} --release
	install -Dm755 -t ${TERMUX_PREFIX}/bin target/${CARGO_TARGET_NAME}/release/macchina
}
