TERMUX_PKG_HOMEPAGE=https://swi-prolog.org/
TERMUX_PKG_DESCRIPTION="Most popular and complete prolog implementation"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="9.3.34"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://www.swi-prolog.org/download/devel/src/swipl-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=89d7c860dcf1261f0a4ae990faaa038168225fe11708252a9d09d45aac8ab583
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

# Function to obtain the .deb URL
obtain_deb_url() {
	local url attempt retries wait PAGE deb_url
	url="https://packages.ubuntu.com/noble/amd64/$1/download"
	retries=50
	wait=50

	>&2 echo "url: $url"

	for ((attempt=1; attempt<=retries; attempt++)); do
		PAGE="$(curl -s "$url")"
		deb_url="$(grep -oE 'https?://.*\.deb' <<< "$PAGE" | head -n1)"
		if [[ -n "$deb_url" ]]; then
				echo "$deb_url"
				return 0
		else
			>&2 echo "Attempt $attempt: Failed to obtain deb URL. Retrying in $wait seconds..."
		fi
		sleep "$wait"
	done

	termux_error_exit "Failed to obtain URL after $retries attempts."
}

_install_ubuntu_packages() {
	# install Ubuntu packages, like in the aosp-libs build.sh
	export HOSTBUILD_ROOTFS="${TERMUX_PKG_HOSTBUILD_DIR}/ubuntu_packages"
	mkdir -p "${HOSTBUILD_ROOTFS}"
	local URL DEB_NAME DEB_LIST

	DEB_LIST="$@"

	for i in $DEB_LIST; do
		echo "deb: $i"
		URL="$(obtain_deb_url "$i")"
		DEB_NAME="${URL##*/}"
		termux_download "$URL" "${TERMUX_PKG_CACHEDIR}/${DEB_NAME}" SKIP_CHECKSUM
		mkdir -p "${TERMUX_PKG_TMPDIR}/${DEB_NAME}"
		ar x "${TERMUX_PKG_CACHEDIR}/${DEB_NAME}" --output="${TERMUX_PKG_TMPDIR}/${DEB_NAME}"
		tar xf "${TERMUX_PKG_TMPDIR}/${DEB_NAME}/data.tar.zst" \
			-C "${HOSTBUILD_ROOTFS}"
	done

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
	_install_ubuntu_packages libacl1-dev \
							libarchive-dev \
							libattr1-dev \
							libext2fs-dev \
							liblz4-dev \
							nettle-dev \
							libpython3-dev \
							libpython3.12-dev \
							python3-dev \
							python3.12-dev \
							libbsd-dev \
							libedit-dev \
							libmd-dev \
							libossp-uuid-dev \
							libossp-uuid16 \
							libdb-dev \
							libdb5.3-dev \
							libodbccr2 \
							libodbcinst2 \
							unixodbc-common \
							unixodbc-dev

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
