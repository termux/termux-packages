TERMUX_SUBPKG_DESCRIPTION="Language Server Protocol implementation for Swift and C-based languages"
TERMUX_SUBPKG_INCLUDE="
bin/sourcekit-lsp
lib/libSwiftSourceKitClientPlugin.so
lib/libSwiftSourceKitPlugin.so
"
TERMUX_SUBPKG_BREAKS="swift (<< 6.3)"
