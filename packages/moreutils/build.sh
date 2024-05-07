TERMUX_PKG_HOMEPAGE=https://joeyh.name/code/moreutils/
TERMUX_PKG_DESCRIPTION="A growing collection of the unix tools that nobody thought to write thirty years ago"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Joshua Kahn @TomJo2000"
TERMUX_PKG_VERSION=0.69
TERMUX_PKG_SRCURL=http://ftp.debian.org/debian/pool/main/m/moreutils/moreutils_$TERMUX_PKG_VERSION.orig.tar.xz
TERMUX_PKG_SHA256=2170c46219ce8d6f17702321534769dfbfece52148a78cd12ea73b5d3a72ff7c
TERMUX_PKG_DEPENDS="perl"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

# chronic requires set of external perl modules.
TERMUX_PKG_RM_AFTER_INSTALL="
bin/chronic
share/man/man1/chronic.1
share/man/man1/parallel.1
"
