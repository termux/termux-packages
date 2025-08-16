TERMUX_PKG_HOMEPAGE=https://hledger.org/
TERMUX_PKG_DESCRIPTION="hledger-ui - terminal interface (TUI) for hledger, a robust, friendly plain text accounting app."
TERMUX_PKG_LICENSE="GPL-3.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.43.2
TERMUX_PKG_SRCURL=https://hackage.haskell.org/package/hledger-ui-${TERMUX_PKG_VERSION}/hledger-ui-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=dbd6b92afd4741811671fa3311384640a10c21afb60964133291d5f266b3e5f7
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_BUILD_DEPENDS="aosp-libs"
TERMUX_PKG_DEPENDS="libffi, libiconv, libgmp, zlib, ncurses, asciinema"
TERMUX_PKG_EXCLUDED_ARCHES="arm, i686"

termux_step_post_configure() {
	cabal get splitmix-0.1.3.1
	mv splitmix{-*,}

	for f in "$TERMUX_PKG_BUILDER_DIR"/splitmix-patches/*.patch; do
		patch --silent -p1 -d splitmix < "$f"
	done

	cabal get entropy-0.4.1.11
	mv entropy{-*,}
	sed -i -E 's|(build-type:\s*)Custom|\1Simple|' entropy/entropy.cabal

	cat <<-EOF >>cabal.project.local
		packages: splitmix entropy

		package splitmix
			benchmarks: False
			tests: False

		package entropy
			flags: +donotgetentropy
	EOF

	if [[ "$TERMUX_ON_DEVICE_BUILD" == false ]]; then # We do not need iserv for on device builds.
		termux_setup_ghc_iserv
		cat <<-EOF >>cabal.project.local
			package *
			    ghc-options: -fexternal-interpreter -pgmi=$(command -v termux-ghc-iserv)
		EOF
	fi
}

termux_step_make() {
	cabal --config="$TERMUX_CABAL_CONFIG" build exe:hledger-ui
}
