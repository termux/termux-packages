TERMUX_PKG_HOMEPAGE=https://atuin.sh/
TERMUX_PKG_DESCRIPTION="Magical shell history"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_LICENSE_FILE="../../LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="18.13.6"
TERMUX_PKG_SRCURL="https://github.com/atuinsh/atuin/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=1d16c1d0f2a9ca104995feaf58a3a20476e729a52336e059247a2f232aeb0f5c
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	termux_setup_protobuf
	termux_setup_rust
	termux_setup_cmake
	TERMUX_PKG_SRCDIR+="/crates/atuin"
	TERMUX_PKG_BUILDDIR="$TERMUX_PKG_SRCDIR"

	# https://github.com/termux/termux-packages/issues/8029
	if [[ "${TERMUX_ARCH}" == "x86_64" ]]; then
		local env_host=$(printf $CARGO_TARGET_NAME | tr a-z A-Z | sed s/-/_/g)
		export CARGO_TARGET_${env_host}_RUSTFLAGS+=" -C link-arg=$($CC -print-libgcc-file-name)"
	fi

	# clash with rust host build
	unset CFLAGS

	cargo vendor
	find ./vendor \
		-mindepth 1 -maxdepth 1 -type d \
		! -wholename ./vendor/rustls-platform-verifier \
		! -wholename ./vendor/serial-core \
		! -wholename ./vendor/serial-unix \
		-exec rm -rf '{}' \;

	find vendor/rustls-platform-verifier -type f -print0 | \
		xargs -0 sed -i \
		-e 's|"android"|"disabling_this_because_it_is_for_building_an_apk"|g' \
		-e "s|ANDROID|DISABLING_THIS_BECAUSE_IT_IS_FOR_BUILDING_AN_APK|g" \
		-e 's|"linux"|"android"|g'

	local patch="$TERMUX_PKG_BUILDER_DIR/serial-unix-termios-0.3.3.diff"
	echo "Applying patch: $patch"
	patch -p1 -d vendor/serial-unix < "$patch"

	echo "" >> Cargo.toml
	echo '[patch.crates-io]' >> Cargo.toml
	echo 'rustls-platform-verifier = { path = "./vendor/rustls-platform-verifier" }' >> Cargo.toml
	echo 'serial-core = { path = "./vendor/serial-core" }' >> Cargo.toml
	echo 'serial-unix = { path = "./vendor/serial-unix" }' >> Cargo.toml
}

termux_step_post_make_install() {
	install -Dm644 /dev/null "$TERMUX_PREFIX"/share/bash-completion/completions/atuin
	install -Dm644 /dev/null "$TERMUX_PREFIX"/share/zsh/site-functions/_atuin
	install -Dm644 /dev/null "$TERMUX_PREFIX"/share/fish/vendor_completions.d/atuin.fish
}

termux_step_create_debscripts() {
	cat <<-EOF >./postinst
		#!${TERMUX_PREFIX}/bin/sh
		atuin gen-completions -s bash > ${TERMUX_PREFIX}/share/bash-completion/completions/atuin
		atuin gen-completions -s zsh > ${TERMUX_PREFIX}/share/zsh/site-functions/_atuin
		atuin gen-completions -s fish > ${TERMUX_PREFIX}/share/fish/vendor_completions.d/atuin.fish
	EOF
}
