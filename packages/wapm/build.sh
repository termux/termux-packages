TERMUX_PKG_HOMEPAGE=https://github.com/wasmerio/wapm-cli
TERMUX_PKG_DESCRIPTION="WebAssembly Package Manager"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.5.9
TERMUX_PKG_SRCURL=https://github.com/wasmerio/wapm-cli/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=67f98e7e584ee05b53a70e19624ca73538aef28f46e1bb31c49262ba0e00a2ec
TERMUX_PKG_REPLACES="wasmer (<< 3.2.1)"
TERMUX_PKG_BREAKS="wasmer (<< 3.2.1)"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	# https://github.com/rust-lang/compiler-builtins#unimplemented-functions
	# https://github.com/rust-lang/rfcs/issues/2629
	# https://github.com/rust-lang/rust/issues/46651
	# https://github.com/termux/termux-packages/issues/8029
	RUSTFLAGS+=" -C link-arg=$(${CC} -print-libgcc-file-name)"
	termux_setup_rust
}

termux_step_make() {
	# https://github.com/wasmerio/wapm-cli/blob/master/Makefile
	cargo build \
		--jobs "${TERMUX_MAKE_PROCESSES}" \
		--target "${CARGO_TARGET_NAME}" \
		--release \
		--features telemetry,update-notifications
}

termux_step_make_install() {
	install -Dm755 "target/${CARGO_TARGET_NAME}/release/wapm" "${TERMUX_PREFIX}/bin/wapm"
	cat <<- EOF > "${TERMUX_PREFIX}/bin/wax"
	#!${TERMUX_PREFIX}/bin/bash
	wapm execute "\$@"
	EOF
	chmod +x "${TERMUX_PREFIX}/bin/wax"
}
