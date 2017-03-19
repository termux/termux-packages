# Fails to build due to not finding struct elf_prstatus.
# It is in <linux/elfcore.h> on Android, but including that file
# causes problems due to elf types being redefined.
TERMUX_PKG_HOMEPAGE=http://www.nongnu.org/libunwind/
TERMUX_PKG_DESCRIPTION="Library to determine the call-chain of a program"
TERMUX_PKG_VERSION=1.2
TERMUX_PKG_SRCURL=http://download.savannah.gnu.org/releases/libunwind/libunwind-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=1de38ffbdc88bd694d10081865871cd2bfbb02ad8ef9e1606aee18d65532b992
