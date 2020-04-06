TERMUX_PKG_HOMEPAGE=http://joeyh.name/code/moreutils/
TERMUX_PKG_DESCRIPTION="A growing collection of the unix tools that nobody thought to write thirty years ago"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=0.63
TERMUX_PKG_SRCURL=http://ftp.debian.org/debian/pool/main/m/moreutils/moreutils_$TERMUX_PKG_VERSION.orig.tar.xz
TERMUX_PKG_SHA256=01f0b331e07e62c70d58c2dabbb68f5c4ddae4ee6f2d8f070fd1e316108af72c
TERMUX_PKG_DEPENDS="perl"
TERMUX_PKG_BUILD_IN_SRC=true

# chronic requires set of external perl modules.
TERMUX_PKG_RM_AFTER_INSTALL="
bin/chronic
share/man/man1/chronic.1
"
