TERMUX_PKG_HOMEPAGE=https://github.com/tummychow/git-absorb
TERMUX_PKG_DESCRIPTION="git commit --fixup, but automatic"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_LICENSE_FILE="LICENSE.md"
TERMUX_PKG_MAINTAINER="Gouranga Das Samrat <gouranga.das.khulna@gmail.com>"
TERMUX_PKG_VERSION="0.9.0"
TERMUX_PKG_SRCURL="https://github.com/tummychow/git-absorb/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=a0f74e6306d7fbd746d2b4a6856621d46a7f82e3e88b6bb8b6fc0480cf811f53
TERMUX_PKG_DEPENDS="zlib"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	termux_setup_rust
}

termux_step_make() {
	cargo build \
		--jobs "$TERMUX_PKG_MAKE_PROCESSES" \
		--target "$CARGO_TARGET_NAME" \
		--release \
		--package git-absorb
}

termux_step_make_install() {
	install -Dm755 -t "$TERMUX_PREFIX/bin" "target/${CARGO_TARGET_NAME}/release/git-absorb"

	# man page (built from Documentation/git-absorb.adoc if a2x/asciidoc is present)
	if [ -f "Documentation/git-absorb.1" ]; then
		install -Dm644 "Documentation/git-absorb.1" \
			"$TERMUX_PREFIX/share/man/man1/git-absorb.1"
	fi
}
