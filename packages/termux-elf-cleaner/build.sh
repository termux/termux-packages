TERMUX_PKG_HOMEPAGE=https://github.com/termux/termux-elf-cleaner
TERMUX_PKG_DESCRIPTION="Cleaner of ELF files for Android"
# NOTE: The termux-elf-cleaner.cpp file is used by build-package.sh
#       to create a native binary. Bumping this version will need
#       updating the checksum used there.
TERMUX_PKG_VERSION=1.1
TERMUX_PKG_SRCURL=https://github.com/termux/termux-elf-cleaner/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=66612b294e197ab7bfac807e497581df58424af6a7c855f89fc12eafa3dc1b8c
TERMUX_PKG_FOLDERNAME=termux-elf-cleaner-$TERMUX_PKG_VERSION
TERMUX_PKG_BUILD_IN_SRC=yes
