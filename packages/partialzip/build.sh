TERMUX_PKG_HOMEPAGE=https://github.com/marcograss/partialzip
TERMUX_PKG_DESCRIPTION="A CLI utility to download file within ZIP archive, without the need to download entire ZIP archive"
TERMUX_PKG_LICENSE="MPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="5.0.0"
TERMUX_PKG_SRCURL=https://github.com/marcograss/partialzip/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=447aa4c7c216e4d67674f0843b283ac0e01320f432cae14385f78619f6813d37
TERMUX_PKG_DEPENDS="openssl, libcurl"
## contains indirect deps from `zip` crate
TERMUX_PKG_BUILD_DEPENDS="bzip2, zstd"
TERMUX_PKG_RECOMMENDS="bzip2, zstd"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make() {
	termux_setup_rust

	cargo build --jobs $TERMUX_PKG_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release
}

termux_step_make_install() {
	install -Dm755 -t $TERMUX_PREFIX/bin target/${CARGO_TARGET_NAME}/release/partialzip
	install -Dm644 -t $TERMUX_PREFIX/share/doc/$TERMUX_PKG_NAME README*
}
