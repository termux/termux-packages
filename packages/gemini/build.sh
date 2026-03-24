TERMUX_PKG_HOMEPAGE=https://github.com/google-gemini/gemini-cli
TERMUX_PKG_DESCRIPTION="A command-line interface for Google's Gemini models"
TERMUX_PKG_LICENSE=Apache-2.0
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.28.2
TERMUX_PKG_SRCURL=https://github.com/google-gemini/gemini-cli/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=c2dd075ce56e80f5ace29b4a49ee99bce35a42d1b94cd26489b89064794fcb0e
TERMUX_PKG_DEPENDS="nodejs"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make() {
    termux_setup_nodejs

    npm install
    npm run bundle
}

termux_step_make_install() {
    install -Dm755 bundle/gemini.js $TERMUX_PREFIX/bin/gemini
}
