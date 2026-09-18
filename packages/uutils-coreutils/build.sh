TERMUX_PKG_HOMEPAGE=https://uutils.github.io/
TERMUX_PKG_DESCRIPTION="Cross-platform Rust rewrite of the GNU coreutils"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Gouranga Das Samrat <gouranga.das.khulna@gmail.com>"
TERMUX_PKG_VERSION="0.11.0"
TERMUX_PKG_SRCURL="https://github.com/uutils/coreutils/archive/refs/tags/$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=a47966117783bef18650cc724f1b1d061b717ac91a0feaabdd34910703cf70a4
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	termux_setup_rust

	# Fix build failure on 32-bit targets (arm, i686), see the patch
	# file for details.
	patch --silent -p1 \
		< "$TERMUX_PKG_BUILDER_DIR"/tail-32bit-stat-mode.diff

	cargo vendor
	find ./vendor \
		-mindepth 1 -maxdepth 1 -type d \
		! -wholename ./vendor/rustix \
		-exec rm -rf '{}' \;

	patch --silent -p1 \
		-d ./vendor/rustix/ \
		< "$TERMUX_PKG_BUILDER_DIR"/rustix-auxv-32bit.diff

	echo "" >> Cargo.toml
	echo '[patch.crates-io]' >> Cargo.toml
	echo "rustix = { path = \"./vendor/rustix\" }" >> Cargo.toml
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

	# MANPAGES/COMPLETIONS need a host-native uudoc build, but CARGOFLAGS
	# above forces cross-compilation, so uudoc can't run on the host here.
	# Generated separately below with a plain cargo build.
	make \
		DESTDIR=/ \
		PREFIX="$TERMUX_PREFIX" \
		PROG_PREFIX=uu- \
		PROFILE=release \
		MULTICALL=y \
		CARGOFLAGS="--target $CARGO_TARGET_NAME" \
		LIBSTDBUF_DIR="$TERMUX_PREFIX/libexec/uutils-coreutils" \
		SELINUX_ENABLED=0 \
		MANPAGES=0 \
		COMPLETIONS=0 \
		SKIP_UTILS="pinky uptime users who hostid chcon runcon"
}

termux_step_make_install() {
	make install \
		DESTDIR=/ \
		PREFIX="$TERMUX_PREFIX" \
		PROG_PREFIX=uu- \
		PROFILE=release \
		MULTICALL=y \
		CARGOFLAGS="--target $CARGO_TARGET_NAME" \
		CARGO_TARGET_DIR="$(pwd)/target/$CARGO_TARGET_NAME" \
		LIBSTDBUF_DIR="$TERMUX_PREFIX/libexec/uutils-coreutils" \
		SELINUX_ENABLED=0 \
		MANPAGES=0 \
		COMPLETIONS=0 \
		SKIP_UTILS="pinky uptime users who hostid chcon runcon"

	# Native (non-cross) build so uudoc can run here; also unset the
	# target toolchain flags so host build-deps (e.g. blake3) don't pick
	# up cross flags like -mfpu=neon.
	(
		unset CC CXX CFLAGS CXXFLAGS CPPFLAGS LDFLAGS AR AS CPP LD RANLIB READELF STRIP
		make install-manpages install-completions \
			DESTDIR=/ \
			PREFIX="$TERMUX_PREFIX" \
			PROG_PREFIX=uu- \
			PROFILE=release \
			MULTICALL=y \
			SKIP_UTILS="pinky uptime users who hostid chcon runcon"
	)
}
