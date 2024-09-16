TERMUX_PKG_HOMEPAGE=https://github.com/mgunyho/tere
TERMUX_PKG_DESCRIPTION="Terminal file explorer written in rust"
TERMUX_PKG_LICENSE="EUPL-1.2"
TERMUX_PKG_LICENSE_FILE="LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.6.0"
TERMUX_PKG_SRCURL=https://github.com/mgunyho/tere/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=7db94216b94abd42f48105c90e0e777593aaf867472615eb94dc2f77bb6a3cfb
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	termux_setup_rust

	: "${CARGO_HOME:=$HOME/.cargo}"
	export CARGO_HOME

	rm -rf $CARGO_HOME/registry/src/*/rustix-*
	cargo fetch --target "${CARGO_TARGET_NAME}"

	for d in $CARGO_HOME/registry/src/*/rustix-*; do
		patch --silent -p1 -d ${d} < $TERMUX_PKG_BUILDER_DIR/0001-rustix-fix-libc-removing-unsafe-on-makedev.diff || :
	done
}

termux_step_make() {
	termux_setup_rust

	cargo build --jobs $TERMUX_PKG_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin target/${CARGO_TARGET_NAME}/release/tere
}
