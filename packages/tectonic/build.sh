TERMUX_PKG_HOMEPAGE=https://tectonic-typesetting.github.io/
TERMUX_PKG_DESCRIPTION="A modernized, complete, self-contained TeX/LaTeX engine"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.16.9"
TERMUX_PKG_SRCURL="https://github.com/tectonic-typesetting/tectonic/archive/refs/tags/tectonic@${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=9861d4d4230b987d8560f1b84fe6c8a550738401be65b9425b0c7d0466178f2b
TERMUX_PKG_DEPENDS="fontconfig, freetype, harfbuzz, libc++, libgraphite, libicu, libpng, openssl, zlib"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make() {
	termux_setup_rust
	cargo build --jobs $TERMUX_PKG_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release --features "external-harfbuzz"
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin target/${CARGO_TARGET_NAME}/release/tectonic
}
