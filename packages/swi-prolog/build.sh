TERMUX_PKG_HOMEPAGE=https://swi-prolog.org/
TERMUX_PKG_DESCRIPTION="Most popular and complete prolog implementation"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="9.3.30"
TERMUX_PKG_SRCURL=https://www.swi-prolog.org/download/devel/src/swipl-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=19f84e3a6915327da4f1bdec3ac4e433bd690b5c29770f5d6fa2740eb23302cf
TERMUX_PKG_DEPENDS="libandroid-execinfo, libarchive, libcrypt, libgmp, libyaml, ncurses, openssl, ossp-uuid, readline, zlib, pcre2"
TERMUX_PKG_FORCE_CMAKE=true
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_AUTO_UPDATE=true
# -DINSTALL_QLF=OFF fixes: "/home/builder/.termux-build/swi-prolog/build/packages/chr//chr.qlf": No such file or directory.
# (and the chr.qlf is not present in the previously successful Termux package swi-prolog version 9.3.22,
# so it is assumed nonessential)
# enable python or java if desired - they are currently not in TERMUX_PKG_DEPENDS, so assumed not wanted currently
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DHAVE_WEAK_ATTRIBUTE_EXITCODE=0
-DINSTALL_DOCUMENTATION=OFF
-DUSE_GMP=ON
-DSWIPL_NATIVE_FRIEND=${TERMUX_PKG_HOSTBUILD_DIR}
-DPOSIX_SHELL=${TERMUX_PREFIX}/bin/sh
-DSWIPL_TMP_DIR=${TERMUX_PREFIX}/tmp
-DSWIPL_INSTALL_IN_LIB=ON
-DSWIPL_PACKAGES_BDB=OFF
-DSWIPL_PACKAGES_ODBC=OFF
-DSWIPL_PACKAGES_GUI=OFF
-DSWIPL_PACKAGES_JAVA=OFF
-DSWIPL_PACKAGES_PYTHON=OFF
-DINSTALL_QLF=OFF
-DINSTALL_TESTS=OFF
-DBUILD_TESTING=OFF
-DSYSTEM_CACERT_FILENAME=${TERMUX_PREFIX}/etc/tls/cert.pem"

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

install_ubuntu_packages() {
	# install Ubuntu packages, like in the aosp-libs build.sh
	HOSTBUILD_ROOTFS="${TERMUX_PKG_HOSTBUILD_DIR}/ubuntu_packages"
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
}

# We do this to produce:
# a native host build to produce
# boot<nn>.prc, INDEX.pl, ssl cetificate tests,
# SWIPL_NATIVE_FRIEND tells SWI-Prolog to use
# this build for the artifacts needed to build the
# Android version
termux_step_host_build() {
	# libarchive-dev for hostbuild fixes: archive4pl: cannot open shared object file: No such file or directory
	# libpython3-dev for hostbuild fixes: janus: cannot open shared object file: No such file or directory
	# (enable python if desired)
	install_ubuntu_packages libacl1-dev \
							libarchive-dev \
							libattr1-dev \
							libext2fs-dev \
							liblz4-dev \
							nettle-dev
							# libpython3-dev \
							# libpython3.12-dev \
							# python3-dev \
							# python3.12-dev

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

	# fixes: fatal error: x86_64-linux-gnu/python3.12/pyconfig.h: No such file or directory
	export CFLAGS+=" -I${HOSTBUILD_ROOTFS}/usr/include"

	# -DSWIPL_SHARED_LIB=ON fixes: libjpl: cannot open shared object file: No such file or directory
	# (enable with java if desired)
	cmake "$TERMUX_PKG_SRCDIR"          \
		-G "Ninja"                      \
		$CMAKE_EXTRA_DEFS               \
		-DCMAKE_PREFIX_PATH="${HOSTBUILD_ROOTFS}/usr" \
		-DINSTALL_DOCUMENTATION=OFF     \
		-DSWIPL_PACKAGES=ON             \
		-DUSE_GMP=OFF                   \
		-DBUILD_TESTING=ON              \
		-DSWIPL_SHARED_LIB=OFF          \
		-DSWIPL_PACKAGES_JAVA=OFF       \
		-DSWIPL_PACKAGES_PYTHON=OFF     \
		-DSWIPL_PACKAGES_BDB=OFF        \
		-DSWIPL_PACKAGES_ODBC=OFF       \
		-DSWIPL_PACKAGES_GUI=OFF
	ninja

	unset LDFLAGS
	unset CFLAGS
	unset CXXFLAGS
}

termux_step_pre_configure() {
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
