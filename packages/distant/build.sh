TERMUX_PKG_HOMEPAGE=https://github.com/chipsenkbeil/distant
TERMUX_PKG_DESCRIPTION="Library and tooling that supports remote filesystem and process"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.20.0-alpha.3
TERMUX_PKG_SRCURL=https://github.com/chipsenkbeil/distant/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=c6c43b7eb868dec5743cbd1c48dfec106cf57129ceef9370f412273f4c7f8975
TERMUX_PKG_DEPENDS="libssh2, openssl, zlib"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	export OPENSSL_NO_VENDOR=1
	export OPENSSL_INCLUDE_DIR=$TERMUX_PREFIX/include/openssl
	export OPENSSL_LIB_DIR=$TERMUX_PREFIX/lib
	export LIBSSH2_SYS_USE_PKG_CONFIG=1
	export PKG_CONFIG_ALLOW_CROSS=1

	termux_setup_rust
	: "${CARGO_HOME:=$HOME/.cargo}"
	export CARGO_HOME

	cargo fetch --target $CARGO_TARGET_NAME

	local d
	local p=termios-0.2.2.diff
	for d in $CARGO_HOME/registry/src/github.com-*/termios-0.2.2; do
		patch --silent -p1 -d ${d} \
			< "$TERMUX_PKG_BUILDER_DIR/${p}" || :
	done
	p=service-manager-0.2.0.diff
	for d in $CARGO_HOME/registry/src/github.com-*/service-manager-*; do
		patch --silent -p1 -d ${d} \
			< "$TERMUX_PKG_BUILDER_DIR/${p}" || :
	done
}

termux_step_make() {
	cargo build --jobs $TERMUX_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin target/${CARGO_TARGET_NAME}/release/distant
}

termux_step_post_massage() {
	mkdir -p ./share/bash-completion/completions
	mkdir -p ./share/zsh/site-functions
	mkdir -p ./share/fish/vendor_completions.d
}

termux_step_create_debscripts() {
	cat <<-EOF > ./postinst
		#!${TERMUX_PREFIX}/bin/sh
		${TERMUX_PREFIX}/bin/distant generate completion bash > ${TERMUX_PREFIX}/share/bash-completion/completions/distant
		${TERMUX_PREFIX}/bin/distant generate completion zsh > ${TERMUX_PREFIX}/share/zsh/site-functions/_distant
		${TERMUX_PREFIX}/bin/distant generate completion fish > ${TERMUX_PREFIX}/share/fish/vendor_completions.d/distant.fish
		exit 0
	EOF
	cat <<-EOF > ./prerm
		#!${TERMUX_PREFIX}/bin/sh
		rm -f ${TERMUX_PREFIX}/share/bash-completion/completions/distant
		rm -f ${TERMUX_PREFIX}/share/zsh/site-functions/_distant
		rm -f ${TERMUX_PREFIX}/share/fish/vendor_completions.d/distant.fish
		exit 0
	EOF
}
