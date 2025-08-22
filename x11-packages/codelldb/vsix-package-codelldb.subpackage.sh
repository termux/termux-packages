TERMUX_SUBPKG_DESCRIPTION="A VSIX package for VSCode-based editors to install to use codelldb"
TERMUX_SUBPKG_INCLUDE="opt/vsix-packages"
# depends on codelldb,
# which depends on lldb,
# which does not exist on 32-bit
TERMUX_SUBPKG_PLATFORM_INDEPENDENT=false
