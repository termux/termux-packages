TERMUX_PKG_HOMEPAGE=https://packages.debian.org/dpkg
TERMUX_PKG_DESCRIPTION="Debian package management system"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.22.21"
# old tarball are removed in https://mirrors.kernel.org/debian/pool/main/d/dpkg/dpkg_${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SRCURL=https://salsa.debian.org/dpkg-team/dpkg/-/archive/${TERMUX_PKG_VERSION}/dpkg-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=81fb9aff0e6e790f5c5d327643b1dea34e89900b0a8e10f48b7ee5fe7c07dd8d
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_DEPENDS="bzip2, coreutils, diffutils, gzip, less, libbz2, liblzma, libmd, tar, xz-utils, zlib, zstd"
TERMUX_PKG_ANTI_BUILD_DEPENDS="clang"
TERMUX_PKG_BREAKS="dpkg-dev"
TERMUX_PKG_REPLACES="dpkg-dev"
TERMUX_PKG_ESSENTIAL=true

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_lib_selinux_setexecfilecon=no
--disable-dselect
--disable-largefile
--disable-shared
dpkg_cv_c99_snprintf=yes
HAVE_SETEXECFILECON_FALSE=#
--host=${TERMUX_ARCH}-linux
--without-selinux
DPKG_PAGER=pager
"

TERMUX_PKG_RM_AFTER_INSTALL="
bin/dpkg-architecture
bin/dpkg-buildflags
bin/dpkg-buildpackage
bin/dpkg-checkbuilddeps
bin/dpkg-distaddfile
bin/dpkg-genbuildinfo
bin/dpkg-genchanges
bin/dpkg-gencontrol
bin/dpkg-gensymbols
bin/dpkg-maintscript-helper
bin/dpkg-mergechangelogs
bin/dpkg-name
bin/dpkg-parsechangelog
bin/dpkg-scansources
bin/dpkg-shlibdeps
bin/dpkg-source
bin/dpkg-statoverride
bin/dpkg-vendor
include
lib
share/dpkg
share/man/man1/dpkg-architecture.1
share/man/man1/dpkg-buildflags.1
share/man/man1/dpkg-buildpackage.1
share/man/man1/dpkg-checkbuilddeps.1
share/man/man1/dpkg-distaddfile.1
share/man/man1/dpkg-genbuildinfo.1
share/man/man1/dpkg-genchanges.1
share/man/man1/dpkg-gencontrol.1
share/man/man1/dpkg-gensymbols.1
share/man/man1/dpkg-maintscript-helper.1
share/man/man1/dpkg-mergechangelogs.1
share/man/man1/dpkg-name.1
share/man/man1/dpkg-parsechangelog.1
share/man/man1/dpkg-scansources.1
share/man/man1/dpkg-shlibdeps.1
share/man/man1/dpkg-source.1
share/man/man1/dpkg-statoverride.1
share/man/man1/dpkg-vendor.1
share/man/man3
share/man/man5
share/polkit-1
"

termux_step_pre_configure() {
	# `dpkg`'s configure script expects the `.dist-version` file to contain the package version.
	# This is missing in the tarballs from salsa.debian.org/dpkg-team/dpkg
	echo "$TERMUX_PKG_VERSION" > "$TERMUX_PKG_SRCDIR/.dist-version"

	# `.dist-vcs-id` isn't strictly required, but configure complains if its missing.
	git ls-remote https://salsa.debian.org/dpkg-team/dpkg.git \
	| grep -F "refs/tags/$TERMUX_PKG_VERSION^{}" \
	| cut -f1 > "$TERMUX_PKG_SRCDIR/.dist-vcs-id"

	( # Do this in a subshell so we don't have to `cd` back
		cd "${TERMUX_PKG_SRCDIR}" && ./autogen
		patch -p1 -i "${TERMUX_PKG_BUILDER_DIR}"/configure.diff
	)
	export TAR=tar # To make sure dpkg tries to use "tar" instead of e.g. "gnutar" (which happens when building on OS X)
	sed -i "s/@TERMUX_ARCH@/$TERMUX_ARCH/" "$TERMUX_PKG_SRCDIR/configure"
	sed -i 's/$req_vars = \$arch_vars.$varname./if ($varname eq "DEB_HOST_ARCH_CPU" or $varname eq "DEB_HOST_ARCH"){ print("'$TERMUX_ARCH'");exit; }; $req_vars = $arch_vars{$varname}/' scripts/dpkg-architecture.pl
}

termux_step_post_massage() {
	mkdir -p "${TERMUX_PKG_MASSAGEDIR}/${TERMUX_PREFIX}/var/lib/dpkg/alternatives"
	mkdir -p "${TERMUX_PKG_MASSAGEDIR}/${TERMUX_PREFIX}/var/lib/dpkg/info"
	mkdir -p "${TERMUX_PKG_MASSAGEDIR}/${TERMUX_PREFIX}/var/lib/dpkg/triggers"
	mkdir -p "${TERMUX_PKG_MASSAGEDIR}/${TERMUX_PREFIX}/var/lib/dpkg/updates"
}
