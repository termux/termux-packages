TERMUX_PKG_HOMEPAGE=https://github.com/podsvirov/mdbook-pikchr
TERMUX_PKG_DESCRIPTION="A mdbook preprocessor to render pikchr code blocks as images in your book"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.1.5"
TERMUX_PKG_SRCURL=https://github.com/podsvirov/mdbook-pikchr.git
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make() {
	termux_setup_rust
	cargo build --jobs $TERMUX_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin target/${CARGO_TARGET_NAME}/release/mdbook-pikchr
}
