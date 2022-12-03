TERMUX_PKG_HOMEPAGE="https://github.com/asciinema/agg"
TERMUX_PKG_DESCRIPTION="asciinema gif generator"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.3.0"
_COMMIT="43977bf11493650e76de0c9d4267bf0b4533255b"
TERMUX_PKG_SRCURL="https://github.com/asciinema/agg/archive/${_COMMIT}.tar.gz"
TERMUX_PKG_SHA256="4122e997de475b2f6d75aabe515407d93adbedb6ba5e573cb373621c67e2c5fd"
TERMUX_PKG_DEPENDS="asciinema"
TERMUX_PKG_BUILD_IN_SRC=true

termux_setup_make_install() {
	termux_setup_rust

	cargo build --jobs "${TERMUX_MAKE_PROCESSES}" --target "${CARGO_TARGET_NAME}" --release

	install -Dm700 target/"${CARGO_TARGET_NAME}"/release/agg /usr/bin/agg
}
