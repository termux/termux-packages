TERMUX_PKG_HOMEPAGE=https://github.com/termux/termux-elf-cleaner
TERMUX_PKG_DESCRIPTION="Cleaner of ELF files for Android"
TERMUX_PKG_LICENSE="GPL-3.0"
# NOTE: The termux-elf-cleaner.cpp file is used by build-package.sh
#       to create a native binary. Bumping this version will need
#       updating the checksum used there.
TERMUX_PKG_VERSION=1.8
TERMUX_PKG_SRCURL=https://github.com/termux/termux-elf-cleaner/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=c5870051fc996a2064b4d4e2ab6139edd8add9127ab6761925e47de925100a87
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_BUILD_IN_SRC=true
