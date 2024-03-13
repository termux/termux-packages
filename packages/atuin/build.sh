TERMUX_PKG_HOMEPAGE=https://atuin.sh/
TERMUX_PKG_DESCRIPTION="Magical shell history"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_LICENSE_FILE="../LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="18.1.0"
TERMUX_PKG_SRCURL=https://github.com/ellie/atuin/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=17712bed6528a7f82cc1dffd56b7effe28270ee2f99247908d7a6adff9474338
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_HOSTBUILD=true

termux_step_pre_configure() {
	TERMUX_PKG_SRCDIR+="/atuin"
	TERMUX_PKG_BUILDDIR="$TERMUX_PKG_SRCDIR"

	# required to build for x86_64, see #8029
	export RUSTFLAGS="${RUSTFLAGS:-} -C link-args=$($CC -print-libgcc-file-name)"
}

termux_step_host_build() {
	export CC=""
	export CFLAGS=""
	export CPPFLAGS=""
	termux_setup_rust

	cd "$TERMUX_PKG_SRCDIR"
	cargo build \
		--jobs $TERMUX_MAKE_PROCESSES \
		--locked \
		--target-dir $TERMUX_PKG_HOSTBUILD_DIR
}

termux_step_post_make_install() {
	# Generate and install shell completions
	mkdir completions/
	for sh in 'bash' 'fish' 'zsh'; do
		$TERMUX_PKG_HOSTBUILD_DIR/debug/atuin gen-completions -s $sh -o completions/
	done

	install -Dm600 completions/atuin.bash $TERMUX_PREFIX/share/bash-completion/completions/atuin.bash
	install -Dm600 completions/_atuin $TERMUX_PREFIX/share/zsh/site-functions/_atuin
	install -Dm600 completions/atuin.fish $TERMUX_PREFIX/share/fish/vendor_completions.d/atuin.fish
}
