TERMUX_PKG_HOMEPAGE=https://lfortran.org/
TERMUX_PKG_DESCRIPTION="A modern open-source interactive Fortran compiler"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.56.0"
TERMUX_PKG_SRCURL=https://github.com/lfortran/lfortran/releases/download/v$TERMUX_PKG_VERSION/lfortran-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=34b92d2f4e6003d06bd981a5f1f082ca16ccab9e56915b15f92a6601a00f7d52
TERMUX_PKG_DEPENDS="clang, libandroid-complex-math, libc++, ncurses, zlib, zstd"
TERMUX_PKG_BUILD_DEPENDS="libkokkos, libllvm-static"
TERMUX_PKG_SUGGESTS="libkokkos"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_SHARED_LIBS=ON
-DWITH_LLVM=yes
-DLLVM_DIR=$TERMUX_PREFIX/lib/cmake/llvm
-DWITH_KOKKOS=yes
-DWITH_RUNTIME_LIBRARY=yes
-DWITH_BFD=no
-DCMAKE_INSTALL_LIBDIR=lib/lfortran
-DWITH_PREBUILT_FORTRAN=$TERMUX_PKG_HOSTBUILD_DIR/src/bin/lfortran
"
TERMUX_PKG_HOSTBUILD=true

# ```
# [...]/src/lfortran/parser/parser_stype.h:97:1: error: static_assert failed
# due to requirement
# 'sizeof(LFortran::YYSTYPE) == sizeof(LFortran::Vec<LFortran::AST::ast_t *>)'
# static_assert(sizeof(YYSTYPE) == sizeof(Vec<AST::ast_t*>));
# ^             ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ```
# Furthermore libkokkos does not support ILP32
TERMUX_PKG_EXCLUDED_ARCHES="arm, i686"

termux_step_host_build() {
	termux_setup_cmake

	cmake $TERMUX_PKG_SRCDIR
	make -j $TERMUX_PKG_MAKE_PROCESSES
}

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-complex-math -lm"
}
