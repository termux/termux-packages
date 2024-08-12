TERMUX_PKG_HOMEPAGE=https://starship.rs
TERMUX_PKG_DESCRIPTION="A minimal, blazing fast, and extremely customizable prompt for any shell"
TERMUX_PKG_LICENSE="ISC"
TERMUX_PKG_MAINTAINER="Joshua Kahn @TomJo2000"
TERMUX_PKG_VERSION="1.20.1"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/starship/starship/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=851d84be69f9171f10890e3b58b8c5ec6057dd873dc83bfe0bdf965f9844b5dc
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_DEPENDS="zlib"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--all-features"
TERMUX_PKG_SUGGESTS="nerdfix, taplo"

termux_step_pre_configure() {
	termux_setup_rust
	termux_setup_cmake
	: "${CARGO_HOME:=${HOME}/.cargo}"
	export CARGO_HOME

	rm -rf "$CARGO_HOME"/registry/src/*/cmake-*
	cargo fetch --target "${CARGO_TARGET_NAME}"

	local dir patch
	patch="cmake-0.1.50-src-lib.rs.diff"
	for dir in "$CARGO_HOME"/registry/src/*/cmake-*; do
		patch --silent -p1 -d "${dir}" \
			< "$TERMUX_PKG_BUILDER_DIR/${patch}"
	done

	local _CARGO_TARGET_LIBDIR="target/${CARGO_TARGET_NAME}/release/deps"
	mkdir -p "${_CARGO_TARGET_LIBDIR}"

	RUSTFLAGS+=" -C link-arg=$($CC -print-libgcc-file-name)"
}

termux_step_post_make_install() {
	# Make a placeholder for shell-completions (to be filled with postinst)
	mkdir -p "${TERMUX_PREFIX}"/share/bash-completion/completions
	mkdir -p "${TERMUX_PREFIX}"/share/elvish/lib
	mkdir -p "${TERMUX_PREFIX}"/share/fish/vendor_completions.d
	mkdir -p "${TERMUX_PREFIX}"/share/zsh/site-functions
	touch "${TERMUX_PREFIX}"/share/bash-completion/completions/starship
	touch "${TERMUX_PREFIX}"/share/elvish/lib/starship.elv
	touch "${TERMUX_PREFIX}"/share/fish/vendor_completions.d/starship.fish
	touch "${TERMUX_PREFIX}"/share/zsh/site-functions/_starship
}

termux_step_post_massage() {
	rm -rf "$CARGO_HOME"/registry/src/*/cmake-*
}

termux_step_create_debscripts() {
	cat <<-EOF >./postinst
		#!${TERMUX_PREFIX}/bin/sh

		starship completions bash > ${TERMUX_PREFIX}/share/bash-completion/completions/starship
		starship completions elvish > "$TERMUX_PREFIX/share/elvish/lib/starship.elv"
		starship completions fish > ${TERMUX_PREFIX}/share/fish/vendor_completions.d/starship.fish
		starship completions zsh > ${TERMUX_PREFIX}/share/zsh/site-functions/_starship
	EOF

	if [[ "$TERMUX_PACKAGE_FORMAT" == 'pacman' ]]; then
		echo 'post_install' > postupg
	fi
}
