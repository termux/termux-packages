TERMUX_PKG_HOMEPAGE=https://github.com/dalance/procs
TERMUX_PKG_DESCRIPTION="A modern replacement for ps"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.14.6"
TERMUX_PKG_SRCURL=https://github.com/dalance/procs/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=3d5cd529c858ca637b166bac908e0d8429c33bdfa9d8db6282f36d5732e4e30a
TERMUX_PKG_BUILD_DEPENDS="asciidoctor"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

# This package contains makefiles to run the tests. So, we need to override build steps.
termux_step_make() {
	termux_setup_rust
	cargo build --jobs $TERMUX_PKG_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release
	asciidoctor -b manpage man/procs.1.adoc
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin target/${CARGO_TARGET_NAME}/release/procs
	install -Dm644 man/procs.1 "$TERMUX_PREFIX"/share/man/man1/procs.1
	install -Dm644 /dev/null "$TERMUX_PREFIX"/share/bash-completion/completions/procs
	install -Dm644 /dev/null "$TERMUX_PREFIX"/share/zsh/site-functions/_procs
	install -Dm644 /dev/null "$TERMUX_PREFIX"/share/fish/vendor_completions.d/procs.fish
}

termux_step_create_debscripts() {
	cat <<-EOF >./postinst
		#!${TERMUX_PREFIX}/bin/sh
		procs --gen-completion-out bash > ${TERMUX_PREFIX}/share/bash-completion/completions/procs
		procs --gen-completion-out zsh > ${TERMUX_PREFIX}/share/zsh/site-functions/_procs
		procs --gen-completion-out fish > ${TERMUX_PREFIX}/share/fish/vendor_completions.d/procs.fish
	EOF
}
