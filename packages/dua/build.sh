TERMUX_PKG_HOMEPAGE=https://github.com/Byron/dua-cli
TERMUX_PKG_DESCRIPTION="View disk space usage and delete unwanted data, fast"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="SunPodder <contact.sunpodder09@gmail.com>"
TERMUX_PKG_VERSION="2.23.0"
TERMUX_PKG_SRCURL=https://github.com/Byron/dua-cli/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=61f6fd0c13949d23224d9776c2fd444956d73dd363501e867cf11df6ca89ddfa
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	termux_setup_rust
}

termux_step_make() {
	cargo build --jobs $TERMUX_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release --no-default-features --features tui-crossplatform
}

termux_step_make_install() {
	install -Dm755 -t $TERMUX_PREFIX/bin target/${CARGO_TARGET_NAME}/release/dua
}

