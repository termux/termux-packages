TERMUX_PKG_HOMEPAGE=https://github.com/sharkdp/fd
TERMUX_PKG_DESCRIPTION="Simple, fast and user-friendly alternative to find"
TERMUX_PKG_LICENSE="Apache-2.0,MIT"
TERMUX_PKG_LICENSE_FILE="LICENSE-APACHE,LICENSE-MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="8.5.3"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/sharkdp/fd/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=45a6444cf5bbfcf4ee4836d9a2ff2106d31e67da77341183392225badc87cd35
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	termux_setup_rust
	cargo build --jobs $TERMUX_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin target/${CARGO_TARGET_NAME}/release/fd

	install -Dm644 /dev/null "${TERMUX_PREFIX}"/share/bash-completion/completions/"${TERMUX_PKG_NAME}".bash
	install -Dm644 /dev/null "${TERMUX_PREFIX}"/share/zsh/site-functions/_"${TERMUX_PKG_NAME}"
	install -Dm644 /dev/null "${TERMUX_PREFIX}"/share/fish/vendor_completions.d/"${TERMUX_PKG_NAME}".fish
}

termux_step_post_make_install() {
	# Manpages.
	install -Dm600 doc/"${TERMUX_PKG_NAME}".1 \
		"${TERMUX_PREFIX}"/share/man/man1/"${TERMUX_PKG_NAME}".1
	
	install -Dm600 contrib/completion/_"${TERMUX_PKG_NAME}" \
		"${TERMUX_PREFIX}"/share/zsh/site-functions/_"${TERMUX_PKG_NAME}"
}

termux_step_create_debscripts() {
	cat <<- EOF > ./postinst
		#!${TERMUX_PREFIX}/bin/sh
		fd --gen-completions bash > ${TERMUX_PREFIX}/share/bash-completion/completions/fd.bash
		fd --gen-completions fish > ${TERMUX_PREFIX}/share/fish/vendor_completions.d/fd.fish
	EOF
}
