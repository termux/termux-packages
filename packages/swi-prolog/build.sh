			   ########################################
			   #	      Set variables		  #
			   ########################################
_TMP_DIR=${TERMUX_PREFIX}/../../cache
TERMUX_PKG_HOMEPAGE=https://swi-prolog.org/
TERMUX_PKG_DESCRIPTION="Most popular and complete prolog implementation"
TERMUX_PKG_VERSION=8.1.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SHA256="865a7eb4a0324b0b5b1ae667a2e2630333d4d889b9427a8653a0c265270a1581"
TERMUX_PKG_SRCURL=http://www.swi-prolog.org/download/devel/src/swipl-${TERMUX_PKG_VERSION}.tar.gz

TERMUX_PKG_DEPENDS="readline, libgmp, libcrypt, pcre, libarchive, libyaml, libjpeg-turbo, ncurses, ncurses-ui-libs, ossp-uuid"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DINSTALL_DOCUMENTATION=OFF
-DUSE_GMP=ON
-DSWIPL_NATIVE_FRIEND=${TERMUX_PKG_HOSTBUILD_DIR}
-DPOSIX_SHELL=${TERMUX_PREFIX}/bin/sh
-DSWIPL_TMP_DIR=${_TMP_DIR}
-DSWIPL_INSTALL_IN_LIB=ON
-DSWIPL_PACKAGES_BDB=OFF
-DSWIPL_PACKAGES_ODBC=OFF
-DSWIPL_PACKAGES_QT=OFF
-DSWIPL_PACKAGES_X=OFF
-DINSTALL_TESTS=ON
-DBUILD_TESTING=ON
-DSYSTEM_CACERT_FILENAME=${TERMUX_PREFIX}/etc/tls/cert.pem"

TERMUX_PKG_FORCE_CMAKE=true
TERMUX_PKG_HOSTBUILD=true

			   ########################################
			   #	      Build in Host		  #
			   #   (in addition to crosscompiling)	  #
			   ########################################
# We do this to produce:
# a native host build to produce
# boot<nn>.prc, INDEX.pl, ssl cetificate tests,
# SWIPL_NATIVE_FRIEND tells SWI-Prolog to use 
# this build for the artifacts needed to build the
# Android version
termux_step_host_build () {
	termux_setup_ninja
	termux_setup_cmake

	if [ $TERMUX_ARCH_BITS = 32 ]; then
	   export LDFLAGS=-m32
	   export CFLAGS=-m32
	   export CXXFLAGS=-m32
	   CMAKE_EXTRA_DEFS="-DCMAKE_LIBRARY_PATH=/usr/lib/i386-linux-gnu"
	else
	   CMAKE_EXTRA_DEFS=""
	fi

	cmake "$TERMUX_PKG_SRCDIR"			     \
	   -G "Ninja"					     \
	   $CMAKE_EXTRA_DEFS				     \
	   -DINSTALL_DOCUMENTATION=OFF			     \
	   -DSWIPL_PACKAGES=ON				     \
	   -DUSE_GMP=OFF				     \
	   -DBUILD_TESTING=ON				     \
	   -DSWIPL_SHARED_LIB=OFF
	ninja

	unset LDFLAGS
	unset CFLAGS
	unset CXXFLAGS
}



			   ########################################
			   #	   Put final libraries and	  #
			   #   binaries in the appropiate place   #
			   ########################################
#Executed after make install
termux_step_post_make_install () {
	mkdir -p ${_TMP_DIR}

	# Remove host build because future builds may be
	# of a different word size (e.g. 32bit or 64bit)
	rm -rf "$TERMUX_PKG_HOSTBUILD_DIR"
}


