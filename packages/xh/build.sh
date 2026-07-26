TERMUX_PKG_HOMEPAGE=https://github.com/ducaale/xh
TERMUX_PKG_DESCRIPTION="A friendly and fast tool for sending HTTP requests"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.26.2"
TERMUX_PKG_SRCURL=https://github.com/ducaale/xh/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=61a88a5b3beac225b75a11d6ed32659af78db7ff29c825def0ab7f4a2906cbd7
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	termux_setup_rust

	# clash with rust host build
	unset CFLAGS

	cargo vendor
	find ./vendor \
		-mindepth 1 -maxdepth 1 -type d \
		! -wholename ./vendor/rustls-platform-verifier \
		-exec rm -rf '{}' \;

	find vendor/rustls-platform-verifier -type f -print0 | \
		xargs -0 sed -i \
		-e 's|"android"|"disabling_this_because_it_is_for_building_an_apk"|g' \
		-e "s|ANDROID|DISABLING_THIS_BECAUSE_IT_IS_FOR_BUILDING_AN_APK|g" \
		-e 's|"linux"|"android"|g'

	echo "" >> Cargo.toml
	echo '[patch.crates-io]' >> Cargo.toml
	echo 'rustls-platform-verifier = { path = "./vendor/rustls-platform-verifier" }' >> Cargo.toml
}

termux_step_make() {
	cargo build --jobs $TERMUX_PKG_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin target/${CARGO_TARGET_NAME}/release/xh
	ln -sf $TERMUX_PREFIX/bin/xh{,s}

	install -Dm600 doc/xh.1 "${TERMUX_PREFIX}"/share/man/man1/xh.1
	install -Dm644 completions/xh.bash "${TERMUX_PREFIX}"/share/bash-completion/completions/xh.bash
	install -Dm644 completions/_xh "${TERMUX_PREFIX}"/share/zsh/site-functions/_xh
	install -Dm644 completions/xh.fish "${TERMUX_PREFIX}"/share/fish/vendor_completions.d/xh.fish
}
