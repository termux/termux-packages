TERMUX_PKG_HOMEPAGE=https://hledger.org/
TERMUX_PKG_DESCRIPTION="Robust, friendly, fast plain text accounting software. (CLI only)"
TERMUX_PKG_LICENSE="GPL-3.0-or-later"
TERMUX_PKG_MAINTAINER="@erplsf"
TERMUX_PKG_VERSION=1.43.2
TERMUX_PKG_SRCURL=https://hackage.haskell.org/package/hledger-${TERMUX_PKG_VERSION}/hledger-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=211e424568acd3a68299958a3284212516be4eaa84f94fbb5c2e0956d5e06f10
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_BUILD_DEPENDS="aosp-libs"
TERMUX_PKG_DEPENDS="libffi, libiconv, libgmp, zlib, ncurses, asciinema"
TERMUX_PKG_EXCLUDED_ARCHES="arm, i686" # upstream doesn't support 32bit

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
	cabal --config="$TERMUX_CABAL_CONFIG" build exe:hledger
}
