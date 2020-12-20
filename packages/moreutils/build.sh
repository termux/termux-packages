TERMUX_PKG_HOMEPAGE=http://joeyh.name/code/moreutils/
TERMUX_PKG_DESCRIPTION="A growing collection of the unix tools that nobody thought to write thirty years ago"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.64
TERMUX_PKG_SRCURL=http://ftp.debian.org/debian/pool/main/m/moreutils/moreutils_$TERMUX_PKG_VERSION.orig.tar.xz
TERMUX_PKG_SHA256=802ce261864d6f9985b56423af422fc5d5cb8e5226aaaf02a6522faa3035662c
TERMUX_PKG_DEPENDS="perl"
TERMUX_PKG_BUILD_IN_SRC=true

# chronic requires set of external perl modules.
TERMUX_PKG_RM_AFTER_INSTALL="
bin/chronic
share/man/man1/chronic.1
share/man/man1/parallel.1
"
