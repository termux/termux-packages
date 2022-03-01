TERMUX_PKG_HOMEPAGE=https://tectonic-typesetting.github.io/
TERMUX_PKG_DESCRIPTION="A modernized, complete, self-contained TeX/LaTeX engine"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.8.0
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/tectonic-typesetting/tectonic.git
TERMUX_PKG_GIT_BRANCH=tectonic@${TERMUX_PKG_VERSION}
TERMUX_PKG_DEPENDS="fontconfig, harfbuzz, libgraphite, libicu, openssl, zlib"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	termux_setup_rust
	cargo build --jobs $TERMUX_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin target/${CARGO_TARGET_NAME}/release/tectonic
}
