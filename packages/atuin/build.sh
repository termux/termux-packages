TERMUX_PKG_HOMEPAGE=https://atuin.sh/
TERMUX_PKG_DESCRIPTION="Magical shell history"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_LICENSE_FILE="../../LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="18.11.0"
TERMUX_PKG_SRCURL=https://github.com/ellie/atuin/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=9d47c1b176be1c0d4a4c16e94dcb55df9c893ee9d2ad6dbc09b4719d5b557645
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
		! -wholename ./vendor/aws-lc-sys \
		-exec rm -rf '{}' \;

	local patch="$TERMUX_PKG_BUILDER_DIR/aws-lc-sys-cmake-system-version.diff"
	local dir="vendor/aws-lc-sys"
	local target="$CCTERMUX_HOST_PLATFORM"
	if [[ "$TERMUX_ARCH" == "arm" ]]; then
		target="armv7a-linux-androideabi$TERMUX_PKG_API_LEVEL"
	fi
	echo "Applying patch: $patch"
	sed -e "s%\@TERMUX_STANDALONE_TOOLCHAIN\@%${TERMUX_STANDALONE_TOOLCHAIN}%g" \
		-e "s%\@TERMUX_PKG_API_LEVEL\@%${TERMUX_PKG_API_LEVEL}%g" \
		-e "s%\@TARGET\@%$target%g" \
		"$patch" | patch --silent -p1 -d "${dir}"

	echo "" >> Cargo.toml
	echo '[patch.crates-io]' >> Cargo.toml
	echo 'aws-lc-sys = { path = "./vendor/aws-lc-sys" }' >> Cargo.toml
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
