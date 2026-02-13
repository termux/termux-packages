TERMUX_PKG_HOMEPAGE=https://swi-prolog.org/
TERMUX_PKG_DESCRIPTION="Most popular and complete prolog implementation"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="10.1.3"
TERMUX_PKG_SRCURL=https://www.swi-prolog.org/download/devel/src/swipl-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=f1fb545f40aef394af2c84dd366b870ad16200b1e28a965f30e370413a0e9052
TERMUX_PKG_DEPENDS="libandroid-execinfo, libarchive, libcrypt, libdb, libedit, libgmp, libyaml, ncurses, openssl, ossp-uuid, pcre2, python, unixodbc, zlib"
TERMUX_PKG_FORCE_CMAKE=true
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_AUTO_UPDATE=true

# configure arguments that should only be applied to the target build, and never the hostbuild
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_INSTALL_LIBDIR=$TERMUX__PREFIX__LIB_SUBDIR
-DCMAKE_INSTALL_INCLUDEDIR=$TERMUX__PREFIX__INCLUDE_SUBDIR
-DHAVE_WEAK_ATTRIBUTE_EXITCODE=0
-DSWIPL_NATIVE_FRIEND=${TERMUX_PKG_HOSTBUILD_DIR}
-DPOSIX_SHELL=${TERMUX_PREFIX}/bin/sh
-DSWIPL_TMP_DIR=${TERMUX_PREFIX}/tmp
-DSYSTEM_CACERT_FILENAME=${TERMUX_PREFIX}/etc/tls/cert.pem
-DODBC_CONFIG=
"

# configure arguments that can/should be kept the same for both the hostbuild and the target build
# (if some of these are not the same, then errors can happen)
_SHARED_EXTRA_CONFIGURE_ARGS="
-DUSE_GMP=ON
-DSYSTEM_LIBEDIT=ON
-DSWIPL_SHARED_LIB=ON
-DSWIPL_INSTALL_IN_LIB=ON
-DSWIPL_PACKAGES=ON
-DSWIPL_PACKAGES_BASIC=ON
-DSWIPL_PACKAGES_BDB=ON
-DSWIPL_PACKAGES_ODBC=ON
-DSWIPL_PACKAGES_PYTHON=ON
-DSWIPL_PACKAGES_JAVA=OFF
-DSWIPL_PACKAGES_GUI=OFF
-DINSTALL_QLF=ON
-DBUILD_TESTING=OFF
-DINSTALL_TESTS=OFF
-DINSTALL_DOCUMENTATION=OFF
"

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
	# make build dependencies of hostbuild exactly match build dependencies of target build
	# prevents possible errors that can otherwise occur
	local -a ubuntu_packages=(
		"libacl1-dev"
		"libarchive-dev"
		"libattr1-dev"
		"libbsd-dev"
		"libdb-dev"
		"libdb5.3-dev"
		"libedit-dev"
		"libext2fs-dev"
		"liblz4-dev"
		"libmd-dev"
		"libodbccr2"
		"libodbcinst2"
		"libossp-uuid-dev"
		"libossp-uuid16"
		"libpython3-dev"
		"libpython3.12-dev"
		"nettle-dev"
		"python3-dev"
		"python3.12-dev"
		"unixodbc-common"
		"unixodbc-dev"
	)

	termux_download_ubuntu_packages "${ubuntu_packages[@]}"

	local HOSTBUILD_ROOTFS="${TERMUX_PKG_HOSTBUILD_DIR}/ubuntu_packages"

	find "${HOSTBUILD_ROOTFS}" -type f -name '*.pc' | \
		xargs -n 1 sed -i -e "s|/usr|${HOSTBUILD_ROOTFS}/usr|g"

	# delete python static libraries to prevent error:
	# relocation R_X86_64_32 against `.rodata' can not be used when making a shared object; recompile with -fPIC
	find "${HOSTBUILD_ROOTFS}" -type f -name '*python*.a' -delete

	find "${HOSTBUILD_ROOTFS}/usr/lib/x86_64-linux-gnu" -xtype l \
		-exec sh -c "ln -snvf /usr/lib/x86_64-linux-gnu/\$(readlink \$1) \$1" sh {} \;

	export LD_LIBRARY_PATH="${HOSTBUILD_ROOTFS}/usr/lib/x86_64-linux-gnu"
	LD_LIBRARY_PATH+=":${HOSTBUILD_ROOTFS}/usr/lib"

	# fixes: fatal error: uuid.h: No such file or directory
	export CFLAGS+=" -I${HOSTBUILD_ROOTFS}/usr/include/ossp"

	# fixes: fatal error: unixodbc.h: No such file or directory
	CFLAGS+=" -I${HOSTBUILD_ROOTFS}/usr/include/x86_64-linux-gnu"

	# fixes: fatal error: x86_64-linux-gnu/python3.12/pyconfig.h: No such file or directory
	CFLAGS+=" -I${HOSTBUILD_ROOTFS}/usr/include"

	local HOSTBUILD_EXTRA_CONFIGURE_ARGS_32=""
	if [[ "$TERMUX_ARCH_BITS" == "32" ]]; then
		export LDFLAGS+=" -m32"
		export CFLAGS+=" -m32"
		export CXXFLAGS+=" -m32 -funwind-tables"
		HOSTBUILD_EXTRA_CONFIGURE_ARGS_32+=" -DCMAKE_LIBRARY_PATH=/usr/lib/i386-linux-gnu"
		# problem: difficult to enable these during hostbuild for 32-bit targets without errors
		HOSTBUILD_EXTRA_CONFIGURE_ARGS_32+=" -DSWIPL_PACKAGES_ODBC=OFF"
		HOSTBUILD_EXTRA_CONFIGURE_ARGS_32+=" -DSWIPL_PACKAGES_PYTHON=OFF"
	fi

	termux_setup_cmake
	termux_setup_ninja

	cmake "$TERMUX_PKG_SRCDIR"                        \
		-G "Ninja"                                    \
		-DCMAKE_PREFIX_PATH="${HOSTBUILD_ROOTFS}/usr" \
		$_SHARED_EXTRA_CONFIGURE_ARGS                 \
		$HOSTBUILD_EXTRA_CONFIGURE_ARGS_32

	ninja

	unset LDFLAGS
	unset CFLAGS
	unset CXXFLAGS
}

termux_step_pre_configure() {
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" $_SHARED_EXTRA_CONFIGURE_ARGS"

	LDFLAGS+=" -landroid-execinfo $($CC -print-libgcc-file-name)"

	local HOSTBUILD_ROOTFS="${TERMUX_PKG_HOSTBUILD_DIR}/ubuntu_packages"

	export LD_LIBRARY_PATH="${HOSTBUILD_ROOTFS}/usr/lib/x86_64-linux-gnu"
	LD_LIBRARY_PATH+=":${HOSTBUILD_ROOTFS}/usr/lib"
}

termux_step_post_make_install() {
	# Remove host build because future builds may be
	# of a different word size (e.g. 32bit or 64bit)
	rm -rf "$TERMUX_PKG_HOSTBUILD_DIR"
}
