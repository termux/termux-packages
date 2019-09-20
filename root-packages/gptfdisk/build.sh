TERMUX_PKG_HOMEPAGE=https://www.rodsbooks.com/gdisk/
TERMUX_PKG_DESCRIPTION="A text-mode partitioning tool that works on GUID Partition Table (GPT) disks"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=1.0.4
TERMUX_PKG_SRCURL=https://sourceforge.net/projects/gptfdisk/files/gptfdisk/$TERMUX_PKG_VERSION/gptfdisk-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=b663391a6876f19a3cd901d862423a16e2b5ceaa2f4a3b9bb681e64b9c7ba78d
TERMUX_PKG_DEPENDS="libpopt, libuuid"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make_install() {
	install -d "$TERMUX_PREFIX"/{bin,share/{doc/gdisk,man/man8}}
	install -t "$TERMUX_PREFIX"/bin/ {,c,s}gdisk fixparts
	install -m600 -t "$TERMUX_PREFIX"/share/man/man8/ {{,c,s}gdisk,fixparts}.8
}
