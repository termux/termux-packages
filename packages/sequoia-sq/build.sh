TERMUX_PKG_HOMEPAGE="https://sequoia-pgp.org/"
TERMUX_PKG_DESCRIPTION="OpenPGP command-line tool from Sequoia"
TERMUX_PKG_LICENSE="GPL-2.0-only"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.3.1
TERMUX_PKG_SRCURL=https://gitlab.com/sequoia-pgp/sequoia-sq/-/archive/v${TERMUX_PKG_VERSION}/sequoia-sq-v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=9f112096f413e195ec737c81abb5649604f16e1f6dbe64a8accc5bb3ad39e239
TERMUX_PKG_DEPENDS="bzip2, libgmp, nettle, openssl, sqlite"
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_host_build() {
	# The `sequoia-keystore` crate requires `capnp` to be available on the build host.
	local CAPNPROTO_SRCURL CAPNPROTO_VERSION CAPNPROTO_SHA256
	read -r CAPNPROTO_SRCURL CAPNPROTO_VERSION CAPNPROTO_SHA256 < <(
		. "$TERMUX_SCRIPTDIR/packages/capnproto/build.sh"
		echo "$TERMUX_PKG_SRCURL $TERMUX_PKG_VERSION $TERMUX_PKG_SHA256"
	)

	termux_download \
		"${CAPNPROTO_SRCURL}" \
		"${TERMUX_PKG_CACHEDIR}/capnproto-${CAPNPROTO_VERSION}.tar.gz" \
		"${CAPNPROTO_SHA256}"

	tar zxf "${TERMUX_PKG_CACHEDIR}/capnproto-${CAPNPROTO_VERSION}.tar.gz" --strip-components=1
	cd c++ || termux_error_exit "Could not run host build for capnproto, no c++ directory in tarball"
	autoreconf -fi
	LDFLAGS="-Wl,-rpath=${TERMUX_PKG_HOSTBUILD_DIR}/c++/.libs" ./configure
	make -j"${TERMUX_PKG_MAKE_PROCESSES}"
	# Run a self test so we find out if `capnp` works before the sequoia-sq build fails
	./.libs/capnp --version || termux_error_exit "Failed to run host-built \`capnp\` binary"
}

termux_step_pre_configure() {
	PATH+=":${TERMUX_PKG_HOSTBUILD_DIR}/c++/.libs"
	termux_setup_rust

	# The `nettle-sys` and `openssl-sys` crates fail to compile if we don't set this.
	HOST_TRIPLET="$(gcc -dumpmachine)"
	PKG_CONFIG_PATH_x86_64_unknown_linux_gnu="$(grep 'DefaultSearchPaths:' "/usr/share/pkgconfig/personality.d/${HOST_TRIPLET}.personality" | cut -d ' ' -f 2)"
	export PKG_CONFIG_PATH_x86_64_unknown_linux_gnu # Declare and export separately, see http://shellcheck.net/wiki/SC2155

	# clashes with rust host build
	unset CFLAGS

	# fix 32bit Android openpgp-cert-d build
	if [[ "$TERMUX_ARCH_BITS" == '32' ]]; then
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
