TERMUX_PKG_HOMEPAGE=https://github.com/ianlancetaylor/libbacktrace
TERMUX_PKG_DESCRIPTION="A C library that may be linked into a C/C++ program to produce symbolic backtraces"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.0+20260601"
TERMUX_PKG_SRCURL=https://github.com/ianlancetaylor/libbacktrace/archive/549b81b43b46c0f361680561a626bf0e7b79dcbd.tar.gz
TERMUX_PKG_SHA256=08c7a62bcbc96edf896ce905c34234618b040b12a376480406652fe045a71c1a
TERMUX_PKG_DEPENDS="zlib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-shared
--with-system-libunwind
"
