TERMUX_PKG_HOMEPAGE=https://github.com/lycheeverse/lychee
TERMUX_PKG_DESCRIPTION="A fast, async, resource-friendly link checker written in Rust"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_LICENSE_FILE="LICENSE-MIT, LICENSE-APACHE"
TERMUX_PKG_MAINTAINER="Yaksh Bariya <thunder-coding@termux.dev>"
TERMUX_PKG_VERSION="0.23.0"
TERMUX_PKG_SRCURL=https://github.com/lycheeverse/lychee/archive/refs/tags/lychee-v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=0c2c7387f5c8916c8c35ffd6102507663de8645da78579231a403020c34db67b
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="openssl, resolv-conf"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="lychee-v\d+\.\d+\.\d+"

termux_step_pre_configure() {
	termux_setup_rust

	: "${CARGO_HOME:=$HOME/.cargo}"
	export CARGO_HOME

	cargo fetch --target "${CARGO_TARGET_NAME}"

	for d in $CARGO_HOME/registry/src/*/trust-dns-resolver-*; do
		sed -e "s|@TERMUX_PREFIX@|$TERMUX_PREFIX|" \
			$TERMUX_PKG_BUILDER_DIR/trust-dns-resolver.diff \
			| patch --silent -p1 -d ${d} || :
	done
}

termux_step_make() {
	cargo build --jobs $TERMUX_PKG_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release
}

termux_step_make_install() {
	install -Dm755 -t $TERMUX_PREFIX/bin target/${CARGO_TARGET_NAME}/release/lychee
}
