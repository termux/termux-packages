TERMUX_PKG_HOMEPAGE=https://nixos.org/patchelf.html
TERMUX_PKG_DESCRIPTION="PatchELF is a small utility to modify the dynamic linker and RPATH of ELF executables."
TERMUX_PKG_VERSION=0.9
local _COMMIT=5a015dafc8710c3cb3475206601d1cdd4cc52f36
TERMUX_PKG_SRCURL=https://github.com/linux-on-android/patchelf/archive/$_COMMIT.zip
TERMUX_PKG_SHA256=e8ee58d6f920ea71b872b50b5e845b5f93c2feb23ad9bf0a370dd0836a7aed40
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_FOLDERNAME=patchelf-$_COMMIT

