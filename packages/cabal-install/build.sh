TERMUX_PKG_HOMEPAGE="https://www.haskell.org/cabal/"
TERMUX_PKG_DESCRIPTION="The command-line interface for Haskell-Cabal and Hackage"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="Aditya Alok <alok@termux.org>"
TERMUX_PKG_VERSION=3.14.1.1
TERMUX_PKG_SRCURL="https://hackage.haskell.org/package/cabal-install-${TERMUX_PKG_VERSION}/cabal-install-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=f11d364ab87fb46275a987e60453857732147780a8c592460eec8a16dbb6bace
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_SUGGESTS="ghc, dnsutils"
TERMUX_PKG_DEPENDS="libffi, libiconv, libgmp, zlib, libandroid-posix-semaphore"
TERMUX_PKG_BUILD_DEPENDS="aosp-libs"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-f-native-dns --ghc-options=-optl-landroid-posix-semaphore"

# Iserv has some linking problem on i686.
# ```
# 	ghc-iserv: /home/builder/.termux-build/_cache/ghc-cross-9.12.1-i686-runtime/lib/ghc-9.12.1/lib/i386-linux-ghc-9.12.1-inplace/ghc-prim-0.13.0-inplace/libHSghc-prim-0.13.0-inplace.a: unhandled ELF relocation(Rel) type 10
# 	ghc-iserv: Failed to lookup symbol: ghczmprim_GHCziTypes_ZMZN_closure
# 	ghc-iserv: ^^ Could not load 'ghczmprim_GHCziCString_unpackCStringzh_closure', dependency unresolved. See top entry above.
# ```
# Disabling it for now. # TODO: Fix it.
TERMUX_PKG_EXCLUDED_ARCHES="i686"

termux_step_post_configure() {
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
