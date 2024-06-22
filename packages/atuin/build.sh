TERMUX_PKG_HOMEPAGE=https://atuin.sh/
TERMUX_PKG_DESCRIPTION="Magical shell history"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_LICENSE_FILE="../../LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="18.3.0"
TERMUX_PKG_SRCURL=https://github.com/ellie/atuin/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=d05d978d1f1b6a633ac24a9ac9bde3b1dfb7416165b053ef54240fff898aded3
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	termux_setup_protobuf
	TERMUX_PKG_SRCDIR+="/crates/atuin"
	TERMUX_PKG_BUILDDIR="$TERMUX_PKG_SRCDIR"

	# required to build for x86_64, see #8029
	export RUSTFLAGS="${RUSTFLAGS:-} -C link-args=$($CC -print-libgcc-file-name)"
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
