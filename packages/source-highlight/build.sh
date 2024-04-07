TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/src-highlite
TERMUX_PKG_DESCRIPTION="convert source code to syntax highlighted document"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_VERSION=3.1.9
TERMUX_PKG_SRCURL=https://ftp.gnu.org/gnu/src-highlite/source-highlight-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=3a7fd28378cb5416f8de2c9e77196ec915145d44e30ff4e0ee8beb3fe6211c91
TERMUX_PKG_DEPENDS="boost"
TERMUX_PKG_BUILD_DEPENDS="boost-headers"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-boost-libdir=$TERMUX_PREFIX/lib"

termux_step_make() {
	# FIXME: doc/Makefile executes the compiled binary, producing
	# dynamic linker error.
	printf "all: \ninstall: \n" > doc/Makefile

	# prevents various undefined reference to __aarch64_*
	# https://github.com/rust-lang/git2-rs/issues/706
	CXXFLAGS+=" -mno-outline-atomics"

	# this package uses throw and ISO C++17 disables it,
	# so we need to rollback to C++14
	CXXFLAGS+=" -std=c++14"
	make CXXFLAGS="$CXXFLAGS"
}
