TERMUX_PKG_HOMEPAGE=https://packages.debian.org/debianutils
TERMUX_PKG_DESCRIPTION="Small utilities which are used primarily by the installation scripts of Debian packages"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=4.8.6.3
TERMUX_PKG_SRCURL=http://ftp.debian.org/debian/pool/main/d/debianutils/debianutils_${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=2cc7de3afc6df1cf6d00af9938efac7ee8f739228e548e512ddc186b6a7be221
TERMUX_PKG_RM_AFTER_INSTALL="bin/installkernel share/man/man8/installkernel.8"
