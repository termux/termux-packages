TERMUX_SUBPKG_INCLUDE="lib/python*"
TERMUX_SUBPKG_DESCRIPTION="The xcbgen Python module"
# Cannot depend on python due to circular dependency.
TERMUX_SUBPKG_RECOMMENDS="python"
TERMUX_SUBPKG_BREAKS="xcb-proto (<< 1.15.2)"
TERMUX_SUBPKG_REPLACES="xcb-proto (<< 1.15.2)"
