TERMUX_PKG_HOMEPAGE=https://packages.debian.org/debianutils
TERMUX_PKG_DESCRIPTION="Small utilities which are used primarily by the installation scripts of Debian packages"
TERMUX_PKG_VERSION=4.8.4
TERMUX_PKG_SHA256=c061ab99aea61f892043b7624b021ab5b193e9c6bbfd474da0fbcdd506be1eb2
TERMUX_PKG_SRCURL=http://ftp.debian.org/debian/pool/main/d/debianutils/debianutils_${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_RM_AFTER_INSTALL="bin/installkernel share/man/man8/installkernel.8"
