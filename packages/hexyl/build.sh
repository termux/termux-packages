TERMUX_PKG_HOMEPAGE=https://github.com/sharkdp/hexyl
TERMUX_PKG_DESCRIPTION="A command-line hex viewer"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.17.0"
TERMUX_PKG_SRCURL=https://github.com/sharkdp/hexyl/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=72fa17397ad187eec6b295d02c7caabbb209a6e0d5706187b8a599bd5df8615e
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	termux_setup_rust
}

termux_step_post_make_install() {
	mkdir -p "${TERMUX_PREFIX}"/share/man/man1
	pandoc --standalone --to man doc/hexyl.1.md --output "${TERMUX_PREFIX}"/share/man/man1/hexyl.1
}
