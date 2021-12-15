TERMUX_SUBPKG_DESCRIPTION="developer compiler libs"
INCLUDED=$(sed 's/^...../opt\/rust-nightly\//' $TERMUX_PKG_BUILDDIR/install/rustc-dev-nightly-$CARGO_TARGET_NAME/rustc-dev/manifest.in | grep -v '\.so$' )
TERMUX_SUBPKG_INCLUDE="$INCLUDED"
