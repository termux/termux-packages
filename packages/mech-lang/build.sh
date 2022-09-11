TERMUX_PKG_HOMEPAGE="https://github.com/mech-lang/mech"
TERMUX_PKG_DESCRIPTION="A programming language for developing data-driven, reactive systems"
TERMUX_PKG_GROUPS="science"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.1-beta"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_SKIP_SRC_EXTRACT=true
TERMUX_PKG_DEPENDS="openssl"
# blacklist non-x86_64 archs due to a linker error on openssl dynamic lib at
# final stage of cargo
TERMUX_PKG_BLACKLISTED_ARCHES="aarch64, arm, i686"

termux_step_get_source() {
	mkdir -p "$TERMUX_PKG_SRCDIR"
	cd "$TERMUX_PKG_SRCDIR"
	git clone "https://gitlab.com/mech-lang/mech" -b "v$TERMUX_PKG_VERSION" \
		--recurse-submodules
	cd mech
	git submodule update --force --recursive --init --remote
}

termux_step_make() {
	termux_setup_rust
	rustup default nightly
	cd "$TERMUX_PKG_SRCDIR/mech"
	cargo build --bin mech --release
}

termux_step_make_install() {
	cd "$TERMUX_PKG_SRCDIR/mech"
	install -Dm755 "target/release/mech" "$TERMUX_PREFIX/bin"
}
