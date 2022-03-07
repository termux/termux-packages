TERMUX_SUBPKG_DESCRIPTION="The Glasgow Haskell Compiler"
TERMUX_SUBPKG_DEPENDS="binutils, llvm, clang"

TERMUX_SUBPKG_INCLUDE="lib/ghc-${TERMUX_PKG_VERSION}/ghc-${TERMUX_PKG_VERSION}"

for f in $(find ${TERMUX_PREFIX}/lib/ghc-${TERMUX_PKG_VERSION}/bin -type f -not -name "ghc-pkg*" -print); do
	TERMUX_SUBPKG_INCLUDE+=" ${f/${TERMUX_PREFIX}\//}"
done
for f in $(find ${TERMUX_PREFIX}/bin -type f -not -name "ghc-pkg*" -print); do
	TERMUX_SUBPKG_INCLUDE+=" ${f/${TERMUX_PREFIX}\//}"
done
