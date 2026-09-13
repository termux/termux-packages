TERMUX_PKG_HOMEPAGE=https://uutils.org/
TERMUX_PKG_DESCRIPTION="Cross-platform Rust rewrite of the GNU coreutils"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Gouranga Das Samrat <gouranga.das.khulna@gmail.com>"
TERMUX_PKG_VERSION="0.12.0"
TERMUX_PKG_SRCURL="https://github.com/uutils/coreutils/archive/refs/tags/$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=4fb327655cb4ffcbf2f16550cf9234079ffe839692f7aa1a6eda104af684e122
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_RM_AFTER_INSTALL="share/locales"

termux_step_pre_configure() {
	termux_setup_rust

	cargo vendor
	find ./vendor \
		-mindepth 1 -maxdepth 1 -type d \
		! -wholename ./vendor/rustix \
		-exec rm -rf '{}' \;

	patch --silent -p1 \
		-d ./vendor/rustix/ \
		< "$TERMUX_PKG_BUILDER_DIR"/rustix-auxv-32bit.diff

	cat <<- EOF >> Cargo.toml

		[patch.crates-io]
		rustix = { path = "./vendor/rustix" }
	EOF

	# Used to provide usage examples in the man pages.
	curl -L \
		https://github.com/tldr-pages/tldr/releases/latest/download/tldr.zip \
		-o "$TERMUX_PKG_SRCDIR/docs/tldr.zip"
}

termux_step_make() {
	termux_setup_rust

	# note: ld.lld: error: undefined reference due to --no-allow-shlib-undefined: syncfs
	local -u env_host="${CARGO_TARGET_NAME//-/_}"
	export RUST_LIBDIR="$TERMUX_PKG_BUILDDIR/_lib"
	mkdir -p "$RUST_LIBDIR"
	export CARGO_TARGET_${env_host}_RUSTFLAGS="-L${RUST_LIBDIR}"
	"${CC}" ${CPPFLAGS} -c "${TERMUX_PKG_BUILDER_DIR}/syncfs.c"
	"${AR}" rcu "${RUST_LIBDIR}/libsyncfs.a" syncfs.o
	export CARGO_TARGET_${env_host}_RUSTFLAGS+=" -C link-arg=-l:libsyncfs.a"

	export "CXXFLAGS_${CARGO_TARGET_NAME//-/_}"="$CXXFLAGS"
	unset CXXFLAGS

	declare -g skipped_utils="chcon hostid pinky runcon uptime users who"
	make \
		LN="ln -s -f" \
		DESTDIR=/ \
		PREFIX="$TERMUX_PREFIX" \
		PROFILE=release \
		PROG_PREFIX=uu- \
		MULTICALL=y \
		CARGOFLAGS="--target $CARGO_TARGET_NAME" \
		LIBSTDBUF_DIR="$TERMUX_PREFIX/libexec/uutils-coreutils" \
		SELINUX_ENABLED=0 \
		MANPAGES=0 \
		COMPLETIONS=0 \
		SKIP_UTILS="${skipped_utils[*]}"
}

termux_step_make_install() {
	make install \
		LN="ln -s -f" \
		DESTDIR=/ \
		PREFIX="$TERMUX_PREFIX" \
		PROFILE=release \
		PROG_PREFIX=uu- \
		MULTICALL=y \
		CARGOFLAGS="--target $CARGO_TARGET_NAME" \
		CARGO_TARGET_DIR="$TERMUX_PKG_SRCDIR/target/$CARGO_TARGET_NAME" \
		LIBSTDBUF_DIR="$TERMUX_PREFIX/libexec/uutils-coreutils" \
		SELINUX_ENABLED=0 \
		MANPAGES=0 \
		COMPLETIONS=0 \
		SKIP_UTILS="${skipped_utils[*]}"
}

termux_step_post_make_install() {
	mkdir -p "${TERMUX_PREFIX}/share/man/man1"
	mkdir -p "${TERMUX_PREFIX}/share/zsh/site-functions"
	mkdir -p "${TERMUX_PREFIX}/share/bash-completion/completions"
	mkdir -p "${TERMUX_PREFIX}/share/fish/vendor_completions.d"
	mkdir -p "${TERMUX_PREFIX}/share/elvish/lib"

	# The `cargo run` invocations below are host builds.
	# Unset the target toolchain variables so they don't clash with the host
	# compiler used by build scripts (e.g. blake3), which breaks 32-bit builds.
	(
		unset CC CXX CFLAGS CXXFLAGS CPPFLAGS LDFLAGS AR AS CPP LD RANLIB READELF STRIP
		export PROG_PREFIX="uu-"
		# Build man pages and completions for all utils and "coreutils", except skipped ones.
		for util in "coreutils" $(cargo run --bin coreutils -- --list); do
			[[ " ${skipped_utils[*]} " == *" ${util} "* ]] && continue
			cargo run --bin uudoc --features uudoc -- \
				manpage    "${util}" | gzip -9 -c -f -n > "${TERMUX_PREFIX}/share/man/man1/${PROG_PREFIX}${util}.1.gz"
			cargo run --bin uudoc --features uudoc -- \
				completion "${util}" bash > "${TERMUX_PREFIX}/share/bash-completion/completions/${PROG_PREFIX}${util}"
			cargo run --bin uudoc --features uudoc -- \
				completion "${util}" elvish > "${TERMUX_PREFIX}/share/elvish/lib/${PROG_PREFIX}${util}.elv"
			cargo run --bin uudoc --features uudoc -- \
				completion "${util}" fish > "${TERMUX_PREFIX}/share/fish/vendor_completions.d/${PROG_PREFIX}${util}.fish"
			cargo run --bin uudoc --features uudoc -- \
				completion "${util}" zsh > "${TERMUX_PREFIX}/share/zsh/site-functions/_${PROG_PREFIX}${util}"
		done
	)
}
