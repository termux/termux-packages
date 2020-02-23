TERMUX_PKG_HOMEPAGE=https://github.com/xploitednoob/dirb
TERMUX_PKG_DESCRIPTION="Web Fuzzer"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Rabby Sheikh @xploitednoob"
TERMUX_PKG_VERSION=2.22
TERMUX_PKG_SRCURL=https://github.com/xploitednoob/dirb/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=5ee46fe97062818913fde670885b3932b7b8de035d5d32232c3f8151059319ca
TERMUX_PKG_DEPENDS="libcurl"

termux_step_post_make_install() {
	mkdir -p "$TERMUX_PREFIX"/share/dirb
	cp -rf  "$TERMUX_PKG_BUILDER_DIR"/wordlists "$TERMUX_PREFIX"/share/dirb/wordlists
}


