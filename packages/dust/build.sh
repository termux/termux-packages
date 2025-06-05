TERMUX_PKG_HOMEPAGE="https://github.com/bootandy/dust"
TERMUX_PKG_DESCRIPTION="A more intuitive version of du in rust"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.2.1"
TERMUX_PKG_SRCURL=https://github.com/bootandy/dust/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=d8ac1a78287a9ea9e6a0e350886dbef8902f5f1dcba9bbc25afafe2ed2ca0a95
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_make_install() {
	install -Dm644 "completions/${TERMUX_PKG_NAME}.bash" "${TERMUX_PREFIX}/share/bash-completion/completions/${TERMUX_PKG_NAME}"
	install -Dm644 "completions/${TERMUX_PKG_NAME}.fish" "${TERMUX_PREFIX}/share/fish/vendor_completions.d/${TERMUX_PKG_NAME}.fish"
	install -Dm644 "completions/_${TERMUX_PKG_NAME}" "${TERMUX_PREFIX}/share/zsh/site-functions/_${TERMUX_PKG_NAME}"
	install -Dm644 "man-page/${TERMUX_PKG_NAME}.1" "${TERMUX_PREFIX}/share/man/man1/${TERMUX_PKG_NAME}.1"
}
