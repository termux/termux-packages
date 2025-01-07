TERMUX_PKG_HOMEPAGE=https://github.com/lsd-rs/lsd
TERMUX_PKG_DESCRIPTION="Next gen ls command"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="Krishna Kanhaiya @kcubeterm"
TERMUX_PKG_VERSION="1.1.5"
TERMUX_PKG_SRCURL=https://github.com/lsd-rs/lsd/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=120935c7e98f9b64488fde39987154a6a5b2236cb65ae847917012adf5e122d1
TERMUX_PKG_DEPENDS="zlib"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	export SHELL_COMPLETIONS_DIR=completions
}

termux_step_post_make_install() {
	install -Dm644 "completions/${TERMUX_PKG_NAME}.bash" "${TERMUX_PREFIX}/share/bash-completion/completions/${TERMUX_PKG_NAME}"
	install -Dm644 "completions/${TERMUX_PKG_NAME}.fish" "${TERMUX_PREFIX}/share/fish/vendor_completions.d/${TERMUX_PKG_NAME}.fish"
	install -Dm644 "completions/_${TERMUX_PKG_NAME}" "${TERMUX_PREFIX}/share/zsh/site-functions/_${TERMUX_PKG_NAME}"
}
