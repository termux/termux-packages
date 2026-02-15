TERMUX_PKG_HOMEPAGE="https://sequoia-pgp.org/"
TERMUX_PKG_DESCRIPTION="OpenPGP command-line tool from Sequoia"
TERMUX_PKG_LICENSE="GPL-2.0-only"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.3.1
TERMUX_PKG_SRCURL=https://gitlab.com/sequoia-pgp/sequoia-sq/-/archive/v${TERMUX_PKG_VERSION}/sequoia-sq-v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=9f112096f413e195ec737c81abb5649604f16e1f6dbe64a8accc5bb3ad39e239
TERMUX_PKG_BUILD_DEPENDS="capnproto"
TERMUX_PKG_DEPENDS="bzip2, libgmp, nettle, openssl, sqlite"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_HOSTBUILD=true

termux_step_host_build() {
	termux_download_ubuntu_packages nettle-dev
	find "${TERMUX_PKG_HOSTBUILD_DIR}/ubuntu_packages" -type f -name '*.pc' | \
		xargs -n 1 sed -i -e "s|/usr|${TERMUX_PKG_HOSTBUILD_DIR}/ubuntu_packages/usr|g"
}

termux_step_pre_configure() {
	termux_setup_rust
	termux_setup_capnp

	# The `openssl-sys` crate fails to compile if we don't set this.
	HOST_TRIPLET="$(gcc -dumpmachine)"
	PKG_CONFIG_PATH_x86_64_unknown_linux_gnu="$(grep 'DefaultSearchPaths:' "/usr/share/pkgconfig/personality.d/${HOST_TRIPLET}.personality" | cut -d ' ' -f 2)"
	export PKG_CONFIG_PATH_x86_64_unknown_linux_gnu # Declare and export separately, see http://shellcheck.net/wiki/SC2155

	# The `nettle-sys` crate fails to compile if we don't set this.
	export PKG_CONFIG_PATH_x86_64_unknown_linux_gnu="$TERMUX_PKG_HOSTBUILD_DIR/ubuntu_packages/usr/lib/x86_64-linux-gnu/pkgconfig:$PKG_CONFIG_PATH_x86_64_unknown_linux_gnu"

	# error: function-like macro '__GLIBC_USE' is not defined
	export BINDGEN_EXTRA_CLANG_ARGS_${CARGO_TARGET_NAME//-/_}="--sysroot ${TERMUX_STANDALONE_TOOLCHAIN}/sysroot --target=${CARGO_TARGET_NAME}"

	# clashes with rust host build
	unset CFLAGS

	# fix 32bit Android openpgp-cert-d build
	if (( TERMUX_ARCH_BITS == 32 )); then
		rm -rf .cargo
		cargo vendor
		mkdir .cargo
		cat <<-EOL >.cargo/config.toml
			[source.crates-io]
			replace-with = "vendored-sources"

			[source.vendored-sources]
			directory = "vendor"

			[patch.crates-io]
			openpgp-cert-d = { path = "./patch-openpgp-cert-d" }
		EOL

		rm -rf patch-openpgp-cert-d
		cp -rf vendor/openpgp-cert-d patch-openpgp-cert-d
		patch -p1 -d patch-openpgp-cert-d -i "${TERMUX_PKG_BUILDER_DIR}/0001-openpgp-cert-d.diff"
	fi
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
	COMPLETIONS_DIR="$(echo "${RELEASE_DIR}"/build/sequoia-sq-*/out/shell-completions)"
	install -Dm700 -t "${TERMUX_PREFIX}/bin" "${RELEASE_DIR}/sq"
	install -Dm600 -t "${TERMUX_PREFIX}/share/man/man1" "${RELEASE_DIR}"/build/sequoia-sq-*/out/man-pages/*.1
	install -Dm600 -t "${TERMUX_PREFIX}/share/bash-completion/completions" "${COMPLETIONS_DIR}/sq.bash"
	install -Dm600 -t "${TERMUX_PREFIX}/share/fish/vendor_completions.d" "${COMPLETIONS_DIR}/sq.fish"
	install -Dm600 -t "${TERMUX_PREFIX}/share/zsh/site-functions" "${COMPLETIONS_DIR}/_sq"
	install -Dm600 -t "${TERMUX_PREFIX}/share/elvish/lib" "${COMPLETIONS_DIR}/sq.elv"
}
