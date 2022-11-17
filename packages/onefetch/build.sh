TERMUX_PKG_HOMEPAGE=https://github.com/o2sh/onefetch
TERMUX_PKG_DESCRIPTION="A command-line Git information tool written in Rust"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@ELWAER-M"
TERMUX_PKG_VERSION="2.13.2"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/o2sh/onefetch/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=6a57e12fb049af89de13aeaf06f206be602e73872458ff4cd5725d3b82289123
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libgit2"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	termux_setup_rust
	termux_setup_cmake

	export CFLAGS="${TARGET_CFLAGS}"

	: "${CARGO_HOME:=$HOME/.cargo}"
	export CARGO_HOME

	rm -rf "${CARGO_HOME}"/registry/src/github.com-*/git-config*
	rm -rf $CARGO_HOME/registry/src/github.com-*/rustix-*
	cargo fetch --target "${CARGO_TARGET_NAME}"

	for d in $CARGO_HOME/registry/src/github.com-*/rustix-*; do
		patch --silent -p1 -d ${d} < $TERMUX_PKG_BUILDER_DIR/0001-upstream-fix-libc-removing-unsafe-on-makedev.diff || :
	done

	for d in $CARGO_HOME/registry/src/github.com-*/git-config*; do
		patch --silent -p1 -d ${d} < $TERMUX_PKG_BUILDER_DIR/0002-rust-git-config-path.diff || :
	done
}

termux_step_make() {
	termux_setup_rust
	cargo build \
		--jobs $TERMUX_MAKE_PROCESSES \
		--target $CARGO_TARGET_NAME \
		--release
}
	
termux_step_make_install() {
	install -Dm700 target/"${CARGO_TARGET_NAME}"/release/onefetch "$TERMUX_PREFIX"/bin

	install -Dm644 /dev/null "$TERMUX_PREFIX"/share/bash-completion/completions/onefetch.bash
	install -Dm644 /dev/null "$TERMUX_PREFIX"/share/zsh/site-functions/_onefetch
	install -Dm644 /dev/null "$TERMUX_PREFIX"/share/fish/vendor_completions.d/onefetch.fish
}

termux_step_create_debscripts() {
	cat <<-EOF >./postinst
		#!${TERMUX_PREFIX}/bin/sh
		onefetch --generate bash > ${TERMUX_PREFIX}/share/bash-completion/completions/onefetch.bash
		onefetch --generate zsh > ${TERMUX_PREFIX}/share/zsh/site-functions/_onefetch
		onefetch --generate fish > ${TERMUX_PREFIX}/share/fish/vendor_completions.d/onefetch.fish
	EOF
}
