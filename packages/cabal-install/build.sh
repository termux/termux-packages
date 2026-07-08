TERMUX_PKG_HOMEPAGE="https://www.haskell.org/cabal/"
TERMUX_PKG_DESCRIPTION="The command-line interface for Haskell-Cabal and Hackage"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="Aditya Alok <alok@termux.dev>"
TERMUX_PKG_VERSION=3.14.1.1
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL="https://hackage.haskell.org/package/cabal-install-${TERMUX_PKG_VERSION}/cabal-install-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=f11d364ab87fb46275a987e60453857732147780a8c592460eec8a16dbb6bace
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_SUGGESTS="ghc, dnsutils"
TERMUX_PKG_DEPENDS="libffi, libiconv, libgmp, zlib, libandroid-posix-semaphore"
TERMUX_PKG_BUILD_DEPENDS="aosp-libs"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-f-native-dns --ghc-options=-optl-landroid-posix-semaphore"

termux_step_post_configure() {
	cabal get splitmix-0.1.3.1
	mv splitmix{-*,}

	for f in "$TERMUX_PKG_BUILDER_DIR"/splitmix-patches/*.patch; do
		patch --silent -p1 -d splitmix < "$f"
	done

	cat <<-EOF >>cabal.project.local
		packages: splitmix

		package splitmix
			benchmarks: False
			tests: False
	EOF

	if [[ "$TERMUX_ON_DEVICE_BUILD" == false ]]; then # We do not need iserv for on device builds.
		termux_setup_ghc_iserv
		cat <<-EOF >>cabal.project.local
			package *
			  ghc-options: -fexternal-interpreter -pgmi=$(command -v termux-ghc-iserv)
		EOF
	fi

	if [[ "$TERMUX_ARCH" == "arm" ]]; then
		cat <<-EOF >>cabal.project.local
			package atomic-counter
			  flags: +no-cmm
		EOF
	fi
}
