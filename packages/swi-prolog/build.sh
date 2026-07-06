TERMUX_PKG_HOMEPAGE=https://swi-prolog.org/
TERMUX_PKG_DESCRIPTION="Most popular and complete prolog implementation"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="10.1.11"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://www.swi-prolog.org/download/devel/src/swipl-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=d2f19aedbc4580517bb79c49ecdccf9cefa9acebdb075a998b5e0c009cbf7ebb
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

_load_ubuntu_packages() {
	export HOSTBUILD_ROOTFS="${TERMUX_PKG_HOSTBUILD_DIR}/ubuntu_packages"
	if [[ "$TERMUX_ARCH_BITS" == "32" ]]; then
		export HOSTBUILD_ARCH="i386"
		export HOSTBUILD_ARCH_LIBDIR="/usr/lib/i386-linux-gnu"
		export HOSTBUILD_ARCH_INCLUDEDIR="/usr/include/i386-linux-gnu"
	else
		export HOSTBUILD_ARCH="amd64"
		export HOSTBUILD_ARCH_LIBDIR="/usr/lib/x86_64-linux-gnu"
		export HOSTBUILD_ARCH_INCLUDEDIR="/usr/include/x86_64-linux-gnu"
	fi
	export LD_LIBRARY_PATH="${HOSTBUILD_ROOTFS}${HOSTBUILD_ARCH_LIBDIR}"
	LD_LIBRARY_PATH+=":${HOSTBUILD_ROOTFS}/usr/lib"
	LD_LIBRARY_PATH+=":${HOSTBUILD_ARCH_LIBDIR}"
}

# We do this to produce:
# a native host build to produce
# boot<nn>.prc, INDEX.pl, ssl cetificate tests,
# SWIPL_NATIVE_FRIEND tells SWI-Prolog to use
# this build for the artifacts needed to build the
# Android version
termux_step_host_build() {
	_load_ubuntu_packages

	# make build dependencies of hostbuild match build dependencies of target build
	# as closely as possible. prevents possible errors that can otherwise occur
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
		"libpython3-dev"
		"libpython3.14-dev"
		"nettle-dev"
		"python3-dev"
		"python3.14-dev"
		"unixodbc-common"
		"unixodbc-dev"
	)

	# these have 64-bit packages preinstalled, but not 32-bit packages
	# it's difficult to precisely calculate which ones are necessary;
	# more were added until all fatal errors disappeared
	if [[ "$HOSTBUILD_ARCH" == "i386" ]]; then
		ubuntu_packages+=("libacl1")
		ubuntu_packages+=("libarchive13t64")
		ubuntu_packages+=("libbsd0")
		ubuntu_packages+=("libdb5.3t64")
		ubuntu_packages+=("libedit2")
		ubuntu_packages+=("libgmp10")
		ubuntu_packages+=("libgmpxx4ldbl")
		ubuntu_packages+=("libltdl-dev")
		ubuntu_packages+=("libltdl7")
		ubuntu_packages+=("liblz4-1")
		ubuntu_packages+=("liblzma5")
		ubuntu_packages+=("libmd0")
		ubuntu_packages+=("libncurses6")
		ubuntu_packages+=("libncursesw6")
		ubuntu_packages+=("libnettle8t64")
		ubuntu_packages+=("libodbc2")
		ubuntu_packages+=("libpcre2-16-0")
		ubuntu_packages+=("libpcre2-32-0")
		ubuntu_packages+=("libpcre2-dev")
		ubuntu_packages+=("libpcre2-posix3")
		ubuntu_packages+=("libpython3.14-minimal")
		ubuntu_packages+=("libpython3.14-stdlib")
		ubuntu_packages+=("libpython3.14")
		ubuntu_packages+=("libtinfo6")
		ubuntu_packages+=("libuuid1")
		ubuntu_packages+=("libxml2-16")
		ubuntu_packages+=("libxxhash0")
		ubuntu_packages+=("libyaml-0-2")
		ubuntu_packages+=("libyaml-dev")
		ubuntu_packages+=("python3.14-minimal")
		ubuntu_packages+=("python3.14")
		ubuntu_packages+=("uuid-dev")
	fi

	# these do not exist for 32-bit x86 Ubuntu
	if [[ "$HOSTBUILD_ARCH" == "amd64" ]]; then
		ubuntu_packages+=("libossp-uuid-dev")
		ubuntu_packages+=("libossp-uuid16")
	fi

	ARCHITECTURE="$HOSTBUILD_ARCH" \
	termux_download_ubuntu_packages "${ubuntu_packages[@]}"

	find "${HOSTBUILD_ROOTFS}" -type f -name '*.pc' | \
		xargs -n 1 sed -i -e "s|/usr|${HOSTBUILD_ROOTFS}/usr|g"

	# delete all static libraries to prevent errors:
	# relocation R_X86_64_32 against `.rodata' can not be used when making a shared object; recompile with -fPIC
	# and
	# undefined reference to`ZSTD_isError'
	find "${HOSTBUILD_ROOTFS}" -type f -name '*.a' -delete

	find "${HOSTBUILD_ROOTFS}${HOSTBUILD_ARCH_LIBDIR}" -xtype l \
		-exec sh -c "ln -snvf ${HOSTBUILD_ARCH_LIBDIR}/\$(readlink \$1) \$1" sh {} \;

	# fixes: fatal error: uuid.h: No such file or directory
	export CFLAGS+=" -I${HOSTBUILD_ROOTFS}/usr/include/ossp"

	# fixes: fatal error: unixodbc.h: No such file or directory
	CFLAGS+=" -I${HOSTBUILD_ROOTFS}${HOSTBUILD_ARCH_INCLUDEDIR}"

	# fixes: fatal error: x86_64-linux-gnu/python3.12/pyconfig.h: No such file or directory
	CFLAGS+=" -I${HOSTBUILD_ROOTFS}/usr/include"

	LDFLAGS+=" -L${HOSTBUILD_ROOTFS}${HOSTBUILD_ARCH_LIBDIR}"

	if [[ "$TERMUX_ARCH_BITS" == "32" ]]; then
		export LDFLAGS+=" -m32"
		export CFLAGS+=" -m32"
		export CXXFLAGS+=" -m32 -funwind-tables"
	fi

	termux_setup_cmake
	termux_setup_ninja

	cmake "$TERMUX_PKG_SRCDIR" \
		-G "Ninja" \
		-DCMAKE_PREFIX_PATH="${HOSTBUILD_ROOTFS}/usr" \
		-DCMAKE_LIBRARY_PATH="${HOSTBUILD_ARCH_LIBDIR}" \
		-DCMAKE_LIBRARY_PATH="${HOSTBUILD_ROOTFS}${HOSTBUILD_ARCH_LIBDIR}" \
		-DOPENSSL_CRYPTO_LIBRARY="${HOSTBUILD_ARCH_LIBDIR}/libcrypto.so" \
		-DOPENSSL_SSL_LIBRARY="${HOSTBUILD_ARCH_LIBDIR}/libssl.so" \
		$_SHARED_EXTRA_CONFIGURE_ARGS

	ninja

	unset LDFLAGS
	unset CFLAGS
	unset CXXFLAGS
}

termux_step_pre_configure() {
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" $_SHARED_EXTRA_CONFIGURE_ARGS"

	LDFLAGS+=" -landroid-execinfo $($CC -print-libgcc-file-name)"

	_load_ubuntu_packages
}

termux_step_post_make_install() {
	# Remove host build because future builds may be
	# of a different word size (e.g. 32bit or 64bit)
	rm -rf "$TERMUX_PKG_HOSTBUILD_DIR"
}
