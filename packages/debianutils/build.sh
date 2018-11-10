TERMUX_PKG_HOMEPAGE=https://packages.debian.org/debianutils
TERMUX_PKG_DESCRIPTION="Small utilities which are used primarily by the installation scripts of Debian packages"
TERMUX_PKG_VERSION=4.8.6
TERMUX_PKG_SHA256=db09047144dadf6a35d0f28977fbef83b0dd60ca32e6c8512cce2444a6423f73
TERMUX_PKG_SRCURL=http://ftp.debian.org/debian/pool/main/d/debianutils/debianutils_${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_RM_AFTER_INSTALL="bin/installkernel share/man/man8/installkernel.8"
