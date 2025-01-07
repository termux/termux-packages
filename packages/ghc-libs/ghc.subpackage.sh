# shellcheck shell=bash
TERMUX_SUBPKG_DESCRIPTION="The Glasgow Haskell Compiler"
TERMUX_SUBPKG_DEPENDS="binutils-is-llvm | binutils, llvm, clang"

TERMUX_SUBPKG_INCLUDE="lib/ghc-$TERMUX_PKG_VERSION/ghc-$TERMUX_PKG_VERSION"

while read -r file; do
	TERMUX_SUBPKG_INCLUDE+=" ${file/$TERMUX_PREFIX\//}"
done < <(find "$TERMUX_PREFIX"/lib/ghc-"$TERMUX_PKG_VERSION"/bin -type f -or -type l -not -name "ghc-pkg*" -print)

while read -r file; do
	TERMUX_SUBPKG_INCLUDE+=" ${file/$TERMUX_PREFIX\//}"
done < <(find "$TERMUX_PREFIX"/bin -type f -or -type l -not -name "ghc-pkg*" -print)
