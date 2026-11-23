TERMUX_PKG_HOMEPAGE=https://joeyh.name/code/moreutils/
TERMUX_PKG_DESCRIPTION="A growing collection of the unix tools that nobody thought to write thirty years ago"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Joshua Kahn <tom@termux.dev>"
TERMUX_PKG_VERSION="0.70"
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL="https://ftp.debian.org/debian/pool/main/m/moreutils/moreutils_$TERMUX_PKG_VERSION.orig.tar.xz"
TERMUX_PKG_SHA256=a844c5e3360a73d12c0a5624750ecc1969d64afea2e84925328f137576e2eb55
TERMUX_PKG_DEPENDS="perl"
TERMUX_PKG_REPLACES="pipebuffer"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
# chronic requires set of external perl modules.
TERMUX_PKG_RM_AFTER_INSTALL="
bin/chronic
share/man/man1/chronic.1.gz
share/man/man1/parallel.1.gz
"
