TERMUX_PKG_HOMEPAGE=https://packages.debian.org/debianutils
TERMUX_PKG_DESCRIPTION="Small utilities which are used primarily by the installation scripts of Debian packages"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=4.11.1
TERMUX_PKG_SRCURL=http://ftp.debian.org/debian/pool/main/d/debianutils/debianutils_${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=8be869f19c55c18d53d9f0414b68bb966a068b2154e9fbbfc6193827d6af983c

TERMUX_PKG_RM_AFTER_INSTALL="
bin/add-shell
bin/installkernel
bin/remove-shell
share/man/man8/add-shell.8
share/man/man8/installkernel.8
share/man/man8/remove-shell.8
"
