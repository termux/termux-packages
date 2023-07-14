TERMUX_PKG_HOMEPAGE=https://age-encryption.org/v1
TERMUX_PKG_DESCRIPTION="A simple, secure and modern encryption tool"
TERMUX_PKG_LICENSE="Apache-2.0, MIT"
TERMUX_PKG_LICENSE_FILE="LICENSE-APACHE, LICENSE-MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.9.2"
TERMUX_PKG_SRCURL=https://github.com/str4d/rage/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=3bd287372eb6226b246459c1b5c39ecdb36b3495d7af4d2bee93bb3aad9ccf65
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make() {
	termux_setup_rust

	cargo build --jobs $TERMUX_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/bin target/${CARGO_TARGET_NAME}/release/rage
	install -Dm700 -t $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/bin target/${CARGO_TARGET_NAME}/release/rage-keygen
}
