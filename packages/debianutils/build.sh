TERMUX_PKG_HOMEPAGE=https://packages.debian.org/debianutils
TERMUX_PKG_DESCRIPTION="Small utilities which are used primarily by the installation scripts of Debian packages"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=4.8.6.2
TERMUX_PKG_SRCURL=http://ftp.debian.org/debian/pool/main/d/debianutils/debianutils_${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=aca388ba52d19f7c2f7991183a1c15c4d375c692a6cb4bae62cd17b485b10bba
TERMUX_PKG_RM_AFTER_INSTALL="bin/installkernel share/man/man8/installkernel.8"
