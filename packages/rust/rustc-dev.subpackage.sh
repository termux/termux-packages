TERMUX_SUBPKG_DESCRIPTION="Rust development compiler libs"
_VERSION=${TERMUX_PKG_VERSION//~*}
_INCLUDED=$(sed 's/^.....//' "${TERMUX_PKG_BUILDDIR}/rustc-dev-${_VERSION}-${CARGO_TARGET_NAME}/rustc-dev/manifest.in" | grep -v '\.so$')
TERMUX_SUBPKG_INCLUDE="${_INCLUDED}"
