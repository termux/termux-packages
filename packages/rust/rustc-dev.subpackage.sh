TERMUX_SUBPKG_DESCRIPTION="developer compiler libs"
INCLUDED=$(sed 's/^.....//' $TERMUX_PKG_BUILDDIR/rustc-dev-$TERMUX_PKG_VERSION-$CARGO_TARGET_NAME/rustc-dev-$CARGO_TARGET_NAME/manifest.in | grep -v '\.so$' )
TERMUX_SUBPKG_INCLUDE="$INCLUDED"
