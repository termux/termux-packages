TERMUX_PKG_HOMEPAGE=https://lfortran.org/
TERMUX_PKG_DESCRIPTION="A modern open-source interactive Fortran compiler"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.45.0
TERMUX_PKG_SRCURL=https://lfortran.github.io/tarballs/release/lfortran-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=41ebda8ca5e51ebd7d2e426f60981e1f5908cd7d64c97ec6f5a2157c4bfbe9ac
TERMUX_PKG_DEPENDS="clang, libandroid-complex-math, libc++, ncurses, zlib, zstd"
TERMUX_PKG_BUILD_DEPENDS="libkokkos, libllvm-static"
TERMUX_PKG_SUGGESTS="libkokkos"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_SHARED_LIBS=ON
-DWITH_LLVM=yes
-DLLVM_DIR=$TERMUX_PREFIX/lib/cmake/llvm
-DWITH_KOKKOS=yes
-DWITH_RUNTIME_LIBRARY=yes
-DWITH_BFD=no
-DCMAKE_INSTALL_LIBDIR=lib/lfortran
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
TERMUX_PKG_BLACKLISTED_ARCHES="arm, i686"

termux_step_host_build() {
	termux_setup_cmake

	cmake $TERMUX_PKG_SRCDIR
	make -j $TERMUX_PKG_MAKE_PROCESSES
}

termux_step_pre_configure() {
	export PATH="$TERMUX_PKG_HOSTBUILD_DIR/src/bin:$PATH"
	echo "Applying CMakeLists.txt.diff"
	sed "s|@TERMUX_PKG_HOSTBUILD_DIR@|${TERMUX_PKG_HOSTBUILD_DIR}|g" \
		$TERMUX_PKG_BUILDER_DIR/CMakeLists.txt.diff \
		| patch --silent -p1

	LDFLAGS+=" -landroid-complex-math -lm"
}
