TERMUX_PKG_HOMEPAGE=https://github.com/termux/termux-elf-cleaner
TERMUX_PKG_DESCRIPTION="Cleaner of ELF files for Android"
TERMUX_PKG_LICENSE="GPL-3.0"
# NOTE: The termux-elf-cleaner.cpp file is used by build-package.sh
#       to create a native binary. Bumping this version will need
#       updating the checksum used there.
TERMUX_PKG_VERSION=1.4
TERMUX_PKG_SRCURL=https://github.com/termux/termux-elf-cleaner/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=a88829b74bef2830fddd5b83eb6569db46dd8045c3eeb3670ab43382cfb7ab3c
TERMUX_PKG_BUILD_IN_SRC=yes
