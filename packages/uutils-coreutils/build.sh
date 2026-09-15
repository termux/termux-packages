TERMUX_PKG_HOMEPAGE=https://uutils.github.io/
TERMUX_PKG_DESCRIPTION="Cross-platform Rust rewrite of the GNU coreutils"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Gouranga Das Samrat <gouranga.das.khulna@gmail.com>"
TERMUX_PKG_VERSION="0.11.0"
TERMUX_PKG_SRCURL=https://github.com/uutils/coreutils/archive/refs/tags/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=a47966117783bef18650cc724f1b1d061b717ac91a0feaabdd34910703cf70a4
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	termux_setup_rust

	# Fix build failure on 32-bit targets (arm, i686): on Android's bionic
	# 32-bit ABI, libc::S_IFMT / libc::S_IFREG are typed as u16 while
	# stat.st_mode is u32 (the same class of libc-crate cross-platform
	# footgun as rust-lang/libc#3161, previously only hit on Windows/macOS
	# code paths, see upstream fix in uutils/coreutils#12140). Widen the
	# constants to u32 so the comparison type-checks on every arch.
	sed -i \
		-e 's/stat\.st_mode & libc::S_IFMT == libc::S_IFREG/stat.st_mode \& u32::from(libc::S_IFMT) == u32::from(libc::S_IFREG)/' \
		src/uu/tail/src/args.rs

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
	local env_host=$(printf $CARGO_TARGET_NAME | tr a-z A-Z | sed s/-/_/g)
	export RUST_LIBDIR=$TERMUX_PKG_BUILDDIR/_lib
	mkdir -p "$RUST_LIBDIR"
	export CARGO_TARGET_${env_host}_RUSTFLAGS="-L${RUST_LIBDIR}"
	"${CC}" ${CPPFLAGS} -c "${TERMUX_PKG_BUILDER_DIR}/syncfs.c"
	"${AR}" rcu "${RUST_LIBDIR}/libsyncfs.a" syncfs.o
	export CARGO_TARGET_${env_host}_RUSTFLAGS+=" -C link-arg=-l:libsyncfs.a"

	_renv="CXXFLAGS_${CARGO_TARGET_NAME//-/_}"
	export $_renv="$CXXFLAGS"
	unset CXXFLAGS

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
}
