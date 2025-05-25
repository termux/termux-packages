TERMUX_PKG_HOMEPAGE=https://github.com/s-yata/marisa-trie
TERMUX_PKG_DESCRIPTION="Matching Algorithm with Recursively Implemented StorAge"
TERMUX_PKG_LICENSE="BSD 2-Clause, LGPL-2.1"
TERMUX_PKG_LICENSE_FILE="COPYING.md"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.2.7"
TERMUX_PKG_SRCURL=https://github.com/s-yata/marisa-trie/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=d4e0097d3a78e2799dfc55c73420d1a43797a2986a4105facfe9a33f4b0ba3c2
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	# fix arm build and potentially other archs hidden bugs
	# ERROR: lib/libmarisa.so contains undefined symbols:
	# 39: 00000000     0 NOTYPE  GLOBAL DEFAULT   UND __aeabi_uidiv
	# 40: 00000000     0 NOTYPE  GLOBAL DEFAULT   UND __aeabi_idiv
	# 49: 00000000     0 NOTYPE  GLOBAL DEFAULT   UND __aeabi_idivmod
	LDFLAGS+=" $($CC -print-libgcc-file-name)"
	autoreconf -fi
}
