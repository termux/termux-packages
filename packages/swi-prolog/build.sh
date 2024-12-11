TERMUX_PKG_HOMEPAGE=https://swi-prolog.org/
TERMUX_PKG_DESCRIPTION="Most popular and complete prolog implementation"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="9.3.16"
TERMUX_PKG_SRCURL=https://www.swi-prolog.org/download/devel/src/swipl-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=24bb77a90259be48729861193865a7c46ce1b0234ff846e8bdb4990c36eed12a
TERMUX_PKG_DEPENDS="libandroid-execinfo, libarchive, libcrypt, libgmp, libyaml, ncurses, openssl, ossp-uuid, readline, zlib, pcre2"
TERMUX_PKG_FORCE_CMAKE=true
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DHAVE_WEAK_ATTRIBUTE_EXITCODE=0
-DHAVE_WEAK_ATTRIBUTE_EXITCODE__TRYRUN_OUTPUT=
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
-DINSTALL_TESTS=OFF
-DBUILD_TESTING=OFF
-DSYSTEM_CACERT_FILENAME=${TERMUX_PREFIX}/etc/tls/cert.pem"

termux_pkg_auto_update() {
	# upstream website recommendes this to get the latest devel version
	local latest_devel='https://www.swi-prolog.org/download/devel/src/swipl-latest.tar.gz'
	local version="$(curl -s "$latest_devel" | grep location | sed -n 's/.*swipl-\([0-9\.]*\).tar.gz.*/\1/p')"
	termux_pkg_upgrade_version "$version"
}

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
		export CXXFLAGS='-m32 -funwind-tables'
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

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-execinfo $($CC -print-libgcc-file-name)"
}

termux_step_post_make_install() {
	# Remove host build because future builds may be
	# of a different word size (e.g. 32bit or 64bit)
	rm -rf "$TERMUX_PKG_HOSTBUILD_DIR"
}
