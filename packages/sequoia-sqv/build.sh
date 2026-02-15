TERMUX_PKG_HOMEPAGE="https://sequoia-pgp.org/"
TERMUX_PKG_DESCRIPTION="Simple OpenPGP signature verification program"
TERMUX_PKG_LICENSE="GPL-2.0-only"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.3.0
TERMUX_PKG_SRCURL=https://gitlab.com/sequoia-pgp/sequoia-sqv/-/archive/v${TERMUX_PKG_VERSION}/sequoia-sqv-v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=0b2db2ec20aa76e7df5fec9768eb6c1950952af02c886d3fa951d4fdf2e2b8d6
TERMUX_PKG_DEPENDS="libgmp, nettle"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_HOSTBUILD=true

termux_step_host_build() {
	termux_download_ubuntu_packages nettle-dev
	find "${TERMUX_PKG_HOSTBUILD_DIR}/ubuntu_packages" -type f -name '*.pc' | \
		xargs -n 1 sed -i -e "s|/usr|${TERMUX_PKG_HOSTBUILD_DIR}/ubuntu_packages/usr|g"
}

termux_step_pre_configure() {
	termux_setup_rust

	# The `nettle-sys` crate fails to compile if we don't set this.
	export PKG_CONFIG_PATH_x86_64_unknown_linux_gnu="$TERMUX_PKG_HOSTBUILD_DIR/ubuntu_packages/usr/lib/x86_64-linux-gnu/pkgconfig"

	# error: function-like macro '__GLIBC_USE' is not defined
	export BINDGEN_EXTRA_CLANG_ARGS_${CARGO_TARGET_NAME//-/_}="--sysroot ${TERMUX_STANDALONE_TOOLCHAIN}/sysroot --target=${CARGO_TARGET_NAME}"

	# clashes with rust host build
	unset CFLAGS
}

termux_step_make() {
	cargo build \
		--features default \
		--jobs "${TERMUX_PKG_MAKE_PROCESSES}" \
		--target "${CARGO_TARGET_NAME}" \
		--release
}

termux_step_make_install() {
	RELEASE_DIR="${TERMUX_PKG_SRCDIR}/target/${CARGO_TARGET_NAME}/release"
	COMPLETIONS_DIR="$(echo "${RELEASE_DIR}"/build/sequoia-sqv-*/out/shell-completions)"
	install -Dm700 -t "${TERMUX_PREFIX}/bin" "${RELEASE_DIR}/sqv"
	install -Dm600 -t "${TERMUX_PREFIX}/share/man/man1" "${RELEASE_DIR}"/build/sequoia-sqv-*/out/man-pages/*.1
	install -Dm600 -t "${TERMUX_PREFIX}/share/bash-completion/completions" "${COMPLETIONS_DIR}/sqv.bash"
	install -Dm600 -t "${TERMUX_PREFIX}/share/fish/vendor_completions.d" "${COMPLETIONS_DIR}/sqv.fish"
	install -Dm600 -t "${TERMUX_PREFIX}/share/zsh/site-functions" "${COMPLETIONS_DIR}/_sqv"
	install -Dm600 -t "${TERMUX_PREFIX}/share/elvish/lib" "${COMPLETIONS_DIR}/sqv.elv"
}
