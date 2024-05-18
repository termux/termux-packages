TERMUX_PKG_HOMEPAGE=https://github.com/extrawurst/gitui
TERMUX_PKG_DESCRIPTION="Blazing fast terminal-ui for git written in rust"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_LICENSE_FILE="LICENSE.md"
TERMUX_PKG_MAINTAINER="@PeroSar"
TERMUX_PKG_VERSION="0.26.2"
TERMUX_PKG_SRCURL=https://github.com/extrawurst/gitui/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=c69eccba2457c53c18b933794aa4ff3dfecb71af42349282108354d543e4d956
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="git, libgit2, libssh2, openssl"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	CPPFLAGS+=" -Dindex=strchr"
	export OPENSSL_NO_VENDOR=1
	export LIBGIT2_SYS_USE_PKG_CONFIG=1
	export LIBSSH2_SYS_USE_PKG_CONFIG=1
	export PKG_CONFIG_ALLOW_CROSS=1

	termux_setup_rust
	: "${CARGO_HOME:=$HOME/.cargo}"
	export CARGO_HOME

	cargo fetch --target "${CARGO_TARGET_NAME}"

	local f
	for f in $CARGO_HOME/registry/src/*/libgit2-sys-*/build.rs; do
		sed -i -E 's/\.range_version\(([^)]*)\.\.[^)]*\)/.atleast_version(\1)/g' "${f}"
	done
}

termux_step_make() {
	cargo build --release \
		--jobs "$TERMUX_MAKE_PROCESSES" \
		--target "$CARGO_TARGET_NAME" \
		--locked
}

termux_step_make_install() {
	install -Dm700 target/"${CARGO_TARGET_NAME}"/release/gitui "$TERMUX_PREFIX"/bin/
}
