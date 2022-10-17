TERMUX_PKG_HOMEPAGE=https://github.com/Aloxaf/silicon
TERMUX_PKG_DESCRIPTION="Silicon is an alternative to Carbon implemented in Rust"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Yaksh Bariya <yakshbari4@gmail.com>"
TERMUX_PKG_VERSION=0.5.1
TERMUX_PKG_SRCURL=https://github.com/Aloxaf/silicon/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=784a6f99001f2000422b676e637fe83a5dc27f5fc55ad33e227c882ce20e6439
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_BUILD_DEPENDS="fontconfig, freetype, harfbuzz"
TERMUX_PKG_BLACKLISTED_ARCHES="arm"

termux_step_pre_configure() {
	termux_setup_rust
	termux_setup_cmake
}

termux_step_make() {
	cargo build --jobs $TERMUX_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release
}

termux_step_make_install() {
	install -Dm755 -t $TERMUX_PREFIX/bin target/${CARGO_TARGET_NAME}/release/silicon
}
