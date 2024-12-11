TERMUX_PKG_HOMEPAGE=https://atuin.sh/
TERMUX_PKG_DESCRIPTION="Magical shell history"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_LICENSE_FILE="../../LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="18.3.0"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/ellie/atuin/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=d05d978d1f1b6a633ac24a9ac9bde3b1dfb7416165b053ef54240fff898aded3
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	termux_setup_protobuf
	termux_setup_rust
	TERMUX_PKG_SRCDIR+="/crates/atuin"
	TERMUX_PKG_BUILDDIR="$TERMUX_PKG_SRCDIR"

	# https://github.com/termux/termux-packages/issues/8029
	if [[ "${TERMUX_ARCH}" == "x86_64" ]]; then
		local env_host=$(printf $CARGO_TARGET_NAME | tr a-z A-Z | sed s/-/_/g)
		export CARGO_TARGET_${env_host}_RUSTFLAGS+=" -C link-arg=$($CC -print-libgcc-file-name)"
	fi

	# clash with rust host build
	unset CFLAGS
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
