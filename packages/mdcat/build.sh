TERMUX_PKG_HOMEPAGE=https://github.com/BIRSAx2/mdcat
TERMUX_PKG_DESCRIPTION="Fancy cat for Markdown: syntax highlighting, images, math, and Mermaid diagrams in your terminal"
TERMUX_PKG_LICENSE="MPL-2.0"
TERMUX_PKG_MAINTAINER="Gouranga Das Samrat <gouranga.das.khulna@gmail.com>"
TERMUX_PKG_VERSION="2.17.0"
TERMUX_PKG_SRCURL=https://github.com/BIRSAx2/mdcat/archive/refs/tags/mdcat-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=91e17168d1059f5524e50442e6623c3e645994c9b09c46867119f142e3f3c465
TERMUX_PKG_DEPENDS="libcurl"
TERMUX_PKG_BUILD_DEPENDS="asciidoctor, perl"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	termux_setup_rust
}

termux_step_make() {
	cargo build \
		--jobs "$TERMUX_PKG_MAKE_PROCESSES" \
		--target "${CARGO_TARGET_NAME}" \
		--features curl/static-ssl \
		--release
}

termux_step_make_install() {
	install -Dm700 \
		"$TERMUX_PKG_SRCDIR/target/${CARGO_TARGET_NAME}/release/mdcat" \
		"$TERMUX_PREFIX/bin/mdcat"
	install -Dm700 \
		"$TERMUX_PKG_SRCDIR/target/${CARGO_TARGET_NAME}/release/mdcat" \
		"$TERMUX_PREFIX/bin/mdless"
	install -Dm700 \
		"$TERMUX_PKG_SRCDIR/target/${CARGO_TARGET_NAME}/release/mdcat" \
		"$TERMUX_PREFIX/bin/mdpick"
}

termux_step_post_make_install() {
	mkdir -p "${TERMUX_PREFIX}/share/man/man1"
	asciidoctor -b manpage -a reproducible -o "${TERMUX_PREFIX}/share/man/man1/mdcat.1" mdcat.1.adoc
	gzip -f "${TERMUX_PREFIX}/share/man/man1/mdcat.1"
	ln -sf mdcat.1.gz "${TERMUX_PREFIX}/share/man/man1/mdless.1.gz"
	ln -sf mdcat.1.gz "${TERMUX_PREFIX}/share/man/man1/mdpick.1.gz"

	mkdir -p "${TERMUX_PREFIX}/share/bash-completion/completions"
	mkdir -p "${TERMUX_PREFIX}/share/zsh/site-functions"
	mkdir -p "${TERMUX_PREFIX}/share/fish/vendor_completions.d"
	mkdir -p "${TERMUX_PREFIX}/share/elvish/lib"

	(
		unset CC CXX CFLAGS CXXFLAGS CPPFLAGS LDFLAGS AR AS CPP LD RANLIB READELF STRIP

		cargo build --features curl/static-ssl

		cp target/debug/mdcat target/debug/mdless
		cp target/debug/mdcat target/debug/mdpick

		for _bin in mdcat mdless mdpick; do
			"target/debug/${_bin}" --completions bash   > "${TERMUX_PREFIX}/share/bash-completion/completions/${_bin}"
			"target/debug/${_bin}" --completions zsh    > "${TERMUX_PREFIX}/share/zsh/site-functions/_${_bin}"
			"target/debug/${_bin}" --completions fish   > "${TERMUX_PREFIX}/share/fish/vendor_completions.d/${_bin}.fish"
			"target/debug/${_bin}" --completions elvish > "${TERMUX_PREFIX}/share/elvish/lib/${_bin}.elv"
		done
	)
}
