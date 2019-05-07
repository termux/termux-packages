TERMUX_PKG_HOMEPAGE=https://swi-prolog.org/
TERMUX_PKG_DESCRIPTION="Most popular and complete prolog implementation"
TERMUX_PKG_LICENSE="ISC"
TERMUX_PKG_VERSION=8.1.5
TERMUX_PKG_SHA256=32f5c4ba701a924b92d0d08d767a07842bca5ba6c149c0c4c5077947530d7bd2
TERMUX_PKG_SRCURL=http://www.swi-prolog.org/download/devel/src/swipl-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="libarchive, libcrypt, libgmp, libjpeg-turbo, libyaml, ncurses, ncurses-ui-libs, pcre, readline, ossp-uuid, zlib"
TERMUX_PKG_FORCE_CMAKE=true
TERMUX_PKG_HOSTBUILD=true

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DINSTALL_DOCUMENTATION=OFF
-DUSE_GMP=ON
-DSWIPL_NATIVE_FRIEND=${TERMUX_PKG_HOSTBUILD_DIR}
-DPOSIX_SHELL=${TERMUX_PREFIX}/bin/sh
-DSWIPL_TMP_DIR=${TERMUX_PREFIX}/tmp
-DSWIPL_INSTALL_IN_LIB=ON
-DSWIPL_PACKAGES_BDB=OFF
-DSWIPL_PACKAGES_ODBC=OFF
-DSWIPL_PACKAGES_QT=OFF
-DSWIPL_PACKAGES_X=OFF
-DINSTALL_TESTS=ON
-DBUILD_TESTING=ON
-DSYSTEM_CACERT_FILENAME=${TERMUX_PREFIX}/etc/tls/cert.pem"

# We do this to produce:
# a native host build to produce
# boot<nn>.prc, INDEX.pl, ssl cetificate tests,
# SWIPL_NATIVE_FRIEND tells SWI-Prolog to use
# this build for the artifacts needed to build the
# Android version
termux_step_host_build() {
	termux_setup_cmake
	termux_setup_ninja

	if [ $TERMUX_ARCH_BITS = 32 ]; then
		export LDFLAGS=-m32
		export CFLAGS=-m32
		export CXXFLAGS=-m32
		CMAKE_EXTRA_DEFS="-DCMAKE_LIBRARY_PATH=/usr/lib/i386-linux-gnu"
	else
		CMAKE_EXTRA_DEFS=""
	fi

	cmake "$TERMUX_PKG_SRCDIR"          \
		-G "Ninja"                      \
		$CMAKE_EXTRA_DEFS               \
		-DINSTALL_DOCUMENTATION=OFF     \
		-DSWIPL_PACKAGES=ON             \
		-DUSE_GMP=OFF                   \
		-DBUILD_TESTING=ON              \
		-DSWIPL_SHARED_LIB=OFF          \
		-DSWIPL_PACKAGES_BDB=OFF        \
		-DSWIPL_PACKAGES_ODBC=OFF       \
		-DSWIPL_PACKAGES_QT=OFF         \
		-DSWIPL_PACKAGES_X=OFF
	ninja

	unset LDFLAGS
	unset CFLAGS
	unset CXXFLAGS
}

termux_step_post_make_install() {
	# Remove host build because future builds may be
	# of a different word size (e.g. 32bit or 64bit)
	rm -rf "$TERMUX_PKG_HOSTBUILD_DIR"
}
