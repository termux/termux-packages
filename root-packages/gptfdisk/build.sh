TERMUX_PKG_HOMEPAGE=https://www.rodsbooks.com/gdisk/
TERMUX_PKG_DESCRIPTION="A text-mode partitioning tool that works on GUID Partition Table (GPT) disks"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.0.10"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://sourceforge.net/projects/gptfdisk/files/gptfdisk/$TERMUX_PKG_VERSION/gptfdisk-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=2abed61bc6d2b9ec498973c0440b8b804b7a72d7144069b5a9209b2ad693a282
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++, libpopt, libuuid, ncurses"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make_install() {
	install -d "$TERMUX_PREFIX"/{bin,share/{doc/gdisk,man/man8}}
	install -t "$TERMUX_PREFIX"/bin/ {,c,s}gdisk fixparts
	install -m600 -t "$TERMUX_PREFIX"/share/man/man8/ {{,c,s}gdisk,fixparts}.8
}
