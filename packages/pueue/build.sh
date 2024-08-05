TERMUX_PKG_HOMEPAGE=https://github.com/Nukesor/pueue
TERMUX_PKG_DESCRIPTION="A command-line task management tool for sequential and parallel execution of long-running tasks"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@stevenxxiu"
TERMUX_PKG_VERSION=3.4.1
TERMUX_PKG_SRCURL=https://github.com/Nukesor/pueue/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=868710de128db49e0a0c4ddee127dfc0e19b20cbdfd4a9d53d5ed792c5538244
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_SERVICE_SCRIPT=("pueued" 'exec pueued 2>&1')

termux_step_pre_configure() {
	termux_setup_rust

	: "${CARGO_HOME:=$HOME/.cargo}"
	export CARGO_HOME

	cargo fetch --target "${CARGO_TARGET_NAME}"
}

termux_step_make() {
	cargo build --jobs $TERMUX_PKG_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin target/${CARGO_TARGET_NAME}/release/pueue
	install -Dm700 -t $TERMUX_PREFIX/bin target/${CARGO_TARGET_NAME}/release/pueued
}

termux_step_post_make_install() {
	# Make a placeholder for shell-completions (to be filled with postinst)
	mkdir -p "${TERMUX_PREFIX}"/share/bash-completions/completions
	mkdir -p "${TERMUX_PREFIX}"/share/elvish/lib
	mkdir -p "${TERMUX_PREFIX}"/share/fish/vendor_completions.d
	mkdir -p "${TERMUX_PREFIX}"/share/nushell/vendor/autoload
	mkdir -p "${TERMUX_PREFIX}"/share/zsh/site-functions
	touch "${TERMUX_PREFIX}"/share/bash-completions/completions/pueue
	touch "${TERMUX_PREFIX}"/share/elvish/lib/pueue.elv
	touch "${TERMUX_PREFIX}"/share/fish/vendor_completions.d/pueue.fish
	touch "${TERMUX_PREFIX}"/share/nushell/vendor/autoload/pueue.nu
	touch "${TERMUX_PREFIX}"/share/zsh/site-functions/_pueue
}

termux_step_create_debscripts() {
	cat <<-EOF >./postinst
		#!${TERMUX_PREFIX}/bin/sh

		pueue completions bash > ${TERMUX_PREFIX}/share/bash-completions/completions/pueue
		pueue completions elvish > ${TERMUX_PREFIX}/share/elvish/lib/pueue.elv
		pueue completions fish > ${TERMUX_PREFIX}/share/fish/vendor_completions.d/pueue.fish
		pueue completions nushell > ${TERMUX_PREFIX}/share/nushell/vendor/autoload/pueue.nu
		pueue completions zsh > ${TERMUX_PREFIX}/share/zsh/site-functions/_pueue
	EOF
}
