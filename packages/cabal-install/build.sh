TERMUX_PKG_HOMEPAGE="https://www.haskell.org/cabal/"
TERMUX_PKG_DESCRIPTION="The command-line interface for Haskell-Cabal and Hackage"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="Aditya Alok <alok@termux.org>"
TERMUX_PKG_VERSION=3.14.1.1
TERMUX_PKG_SRCURL="https://hackage.haskell.org/package/cabal-install-${TERMUX_PKG_VERSION}/cabal-install-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=f11d364ab87fb46275a987e60453857732147780a8c592460eec8a16dbb6bace
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_SUGGESTS="ghc"
TERMUX_PKG_DEPENDS="libffi, libiconv, libgmp, zlib, libandroid-posix-semaphore"
TERMUX_PKG_BUILD_DEPENDS="aosp-libs"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-f-native-dns --ghc-options=-optl-landroid-posix-semaphore"
TERMUX_PKG_USES_HASKELL_TEMPLATE=true
