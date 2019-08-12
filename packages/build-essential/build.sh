TERMUX_PKG_HOMEPAGE=https://github.com/termux/termux-packages
TERMUX_PKG_DESCRIPTION="A metapackage that installs essential development tools"
TERMUX_PKG_LICENSE="Public Domain"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
TERMUX_PKG_VERSION=3.1
TERMUX_PKG_REVISION=4
TERMUX_PKG_METAPACKAGE=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

#
# Common utilities for various build systems:
#
#   autoconf, automake, bison, clang, cmake, flex, gperf, libtool, m4, make, ninja, pkg-config, util-linux
#
# These packages replace busybox's applets:
#
#   bc, bzip2, coreutils, diffutils, ed, findutils, gawk, grep, gzip, lzip, lzop, patch, procps, psmisc, sed, tar, xz-utils
#

TERMUX_PKG_DEPENDS="autoconf, automake, bison, clang, cmake, flex, gperf, libtool, m4, make, ninja, pkg-config, bc, bzip2, coreutils, diffutils, ed, findutils, gawk, grep, gzip, lzip, lzop, patch, procps, psmisc, sed, tar, util-linux, xz-utils"

# Other packages that may be interesting.
TERMUX_PKG_SUGGESTS="git, golang, nodejs, patchelf, proot, python, python2, ruby, rust, subversion"
