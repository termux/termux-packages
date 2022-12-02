TERMUX_PKG_HOMEPAGE=https://packages.debian.org/dpkg
TERMUX_PKG_DESCRIPTION="Debian package management system"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.21.10
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/debian/pool/main/d/dpkg/dpkg_${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=98056f5bd0b2456bc2271322fb749cced75d7f8c883bcf10f9812e67df20f262
TERMUX_PKG_DEPENDS="bzip2, coreutils, diffutils, gzip, less, libbz2, liblzma, libmd, tar, xz-utils, zlib"
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
	export TAR=tar # To make sure dpkg tries to use "tar" instead of e.g. "gnutar" (which happens when building on OS X)
	perl -p -i -e "s/TERMUX_ARCH/$TERMUX_ARCH/" $TERMUX_PKG_SRCDIR/configure
	sed -i 's/$req_vars = \$arch_vars.$varname./if ($varname eq "DEB_HOST_ARCH_CPU" or $varname eq "DEB_HOST_ARCH"){ print("'$TERMUX_ARCH'");exit; }; $req_vars = $arch_vars{$varname}/' scripts/dpkg-architecture.pl
}

termux_step_post_massage() {
	mkdir -p "${TERMUX_PKG_MASSAGEDIR}/${TERMUX_PREFIX}/var/lib/dpkg/alternatives"
	mkdir -p "${TERMUX_PKG_MASSAGEDIR}/${TERMUX_PREFIX}/var/lib/dpkg/info"
	mkdir -p "${TERMUX_PKG_MASSAGEDIR}/${TERMUX_PREFIX}/var/lib/dpkg/triggers"
	mkdir -p "${TERMUX_PKG_MASSAGEDIR}/${TERMUX_PREFIX}/var/lib/dpkg/updates"
}
