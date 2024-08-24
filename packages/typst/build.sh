TERMUX_PKG_HOMEPAGE=https://typst.app/
TERMUX_PKG_DESCRIPTION="A new markup-based typesetting system that is powerful and easy to learn"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.11.1"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=git+https://github.com/typst/typst
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="openssl"

termux_step_pre_configure() {
	termux_setup_rust

	: "${CARGO_HOME:=$HOME/.cargo}"
	export CARGO_HOME

	cargo vendor
	patch --silent -p1 \
		-d ./vendor/time/ \
		< "$TERMUX_PKG_BUILDER_DIR"/time-items-format_items.diff

	echo "" >> Cargo.toml
	echo '[patch.crates-io]' >> Cargo.toml
	echo 'time = { path = "./vendor/time" }' >> Cargo.toml
}

termux_step_make() {
	termux_setup_rust

	export GEN_ARTIFACTS=artifacts
	export OPENSSL_NO_VENDOR=1
	cargo build --jobs $TERMUX_PKG_MAKE_PROCESSES -p typst-cli --target $CARGO_TARGET_NAME --release
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin target/${CARGO_TARGET_NAME}/release/typst

	local _artifacts="crates/typst-cli/artifacts"
	install -Dm644 -t "${TERMUX_PREFIX}/share/man/man1/" "${_artifacts}/${TERMUX_PKG_NAME}"*.1
	install -Dm644 -t "${TERMUX_PREFIX}/share/zsh/site-functions/" "${_artifacts}/_${TERMUX_PKG_NAME}"
	install -Dm644 -t "${TERMUX_PREFIX}/share/fish/vendor_completions.d/" "${_artifacts}/${TERMUX_PKG_NAME}.fish"
	install -Dm644 "${_artifacts}/${TERMUX_PKG_NAME}.bash" "${TERMUX_PREFIX}/share/bash-completion/completions/${TERMUX_PKG_NAME}"
}

termux_step_post_make_install() {
	# Remove the vendor sources to save space
	rm -rf "$TERMUX_PKG_SRCDIR"/vendor
}
