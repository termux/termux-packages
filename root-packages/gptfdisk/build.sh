TERMUX_PKG_HOMEPAGE=https://www.rodsbooks.com/gdisk/
TERMUX_PKG_DESCRIPTION="A text-mode partitioning tool that works on GUID Partition Table (GPT) disks"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.0.5
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://sourceforge.net/projects/gptfdisk/files/gptfdisk/$TERMUX_PKG_VERSION/gptfdisk-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=0e7d3987cd0488ecaf4b48761bc97f40b1dc089e5ff53c4b37abe30bc67dcb2f
TERMUX_PKG_DEPENDS="libpopt, libuuid, ncurses"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make_install() {
	install -d "$TERMUX_PREFIX"/{bin,share/{doc/gdisk,man/man8}}
	install -t "$TERMUX_PREFIX"/bin/ {,c,s}gdisk fixparts
	install -m600 -t "$TERMUX_PREFIX"/share/man/man8/ {{,c,s}gdisk,fixparts}.8
}
