TERMUX_PKG_HOMEPAGE=https://github.com/SeaQL/sea-orm
TERMUX_PKG_DESCRIPTION="Command line utility for SeaORM, an async & dynamic ORM for Rust"
TERMUX_PKG_LICENSE="MIT,Apache-2.0"
TERMUX_PKG_LICENSE_FILE="LICENSE-MIT,LICENSE-APACHE"
TERMUX_PKG_MAINTAINER="Gouranga Das Samrat <gouranga.das.khulna@gmail.com>"
TERMUX_PKG_VERSION="2.0.2"
TERMUX_PKG_SRCURL=https://github.com/SeaQL/sea-orm/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=1f4421a018591aa00e83f63c07f50d6e1326b118fb7ee83ed5ef293f54c7ede5
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_DEPENDS="openssl"
TERMUX_PKG_BUILD_DEPENDS="openssl-static"

termux_step_make() {
	termux_setup_rust

	export OPENSSL_DIR="${TERMUX_PREFIX}"
	export OPENSSL_LIB_DIR="${TERMUX_PREFIX}/lib"
	export OPENSSL_INCLUDE_DIR="${TERMUX_PREFIX}/include"

	cd sea-orm-cli
	cargo build \
		--release \
		--features cli,codegen \
		--target ${CARGO_TARGET_NAME}
}

termux_step_make_install() {
	install -Dm755 \
		sea-orm-cli/target/${CARGO_TARGET_NAME}/release/sea-orm-cli \
		"$TERMUX_PREFIX/bin/sea-orm-cli"
}
