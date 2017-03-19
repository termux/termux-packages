# Fails to build due to not finding struct elf_prstatus.
# It is in <linux/elfcore.h> on Android, but including that file
# causes problems due to elf types being redefined.
TERMUX_PKG_HOMEPAGE=http://www.nongnu.org/libunwind/
TERMUX_PKG_DESCRIPTION="Library to determine the call-chain of a program"
TERMUX_PKG_VERSION=1.2.2017.03.04
local _COMMIT=2b8ab794b3a636c05396fdbaebbba25d8aa4722a
TERMUX_PKG_SRCURL=https://github.com/libunwind/libunwind/archive/${_COMMIT}.zip
TERMUX_PKG_SHA256=fdbe8f0348a0db86663fdf7a363fcb281fef220f85bd751db8ed13aca00c062d
TERMUX_PKG_FOLDERNAME=libunwind-$_COMMIT
# TERMUX_PKG_SRCURL=http://download.savannah.gnu.org/releases/libunwind/libunwind-${TERMUX_PKG_VERSION}.tar.gz
# TERMUX_PKG_SHA256=1de38ffbdc88bd694d10081865871cd2bfbb02ad8ef9e1606aee18d65532b992

termux_step_post_extract_package() {
	NOCONFIGURE=1 ./autogen.sh
}
