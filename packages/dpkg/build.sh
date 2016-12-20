TERMUX_PKG_HOMEPAGE=https://packages.debian.org/dpkg
TERMUX_PKG_DESCRIPTION="Debian package management system"
TERMUX_PKG_VERSION=1.18.18
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/debian/pool/main/d/dpkg/dpkg_${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=c88b61e3d4660500753142689e8ddbeff1c731f29549f3338e6975f655936ff5
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-dselect --disable-shared --disable-start-stop-daemon --disable-largefile --disable-update-alternatives --host=${TERMUX_ARCH}-linux --without-selinux dpkg_cv_c99_snprintf=yes ac_cv_lib_selinux_setexecfilecon=no HAVE_SETEXECFILECON_FALSE=#"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --without-libbz2"
TERMUX_PKG_RM_AFTER_INSTALL="lib/perl5 share/perl5 lib/dpkg/parsechangelog bin/dpkg-architecture bin/dpkg-buildflags bin/dpkg-buildpackage bin/dpkg-checkbuilddeps bin/dpkg-distaddfile bin/dpkg-genchanges bin/dpkg-gencontrol bin/dpkg-gensymbols bin/dpkg-maintscript-helper bin/dpkg-mergechangelogs bin/dpkg-name bin/dpkg-parsechangelog bin/dpkg-scanpackages bin/dpkg-scansources bin/dpkg-shlibdeps bin/dpkg-source bin/dpkg-statoverride bin/dpkg-vendor share/man/man1/dpkg-architecture.1 share/man/man1/dpkg-buildflags.1 share/man/man1/dpkg-buildpackage.1 share/man/man1/dpkg-checkbuilddeps.1 share/man/man1/dpkg-distaddfile.1 share/man/man1/dpkg-genchanges.1 share/man/man1/dpkg-gencontrol.1 share/man/man1/dpkg-gensymbols.1 share/man/man1/dpkg-maintscript-helper.1 share/man/man1/dpkg-mergechangelogs.1 share/man/man1/dpkg-name.1 share/man/man1/dpkg-parsechangelog.1 share/man/man1/dpkg-scanpackages.1 share/man/man1/dpkg-scansources.1 share/man/man1/dpkg-shlibdeps.1 share/man/man1/dpkg-source.1 share/man/man1/dpkg-vendor.1 share/man/man8/dpkg-statoverride.8 share/man/man3"
# with the extract.c.patch we remove the -p and --warning=no-timestamp tar options so we can use busybox tar
TERMUX_PKG_DEPENDS="busybox, liblzma"
TERMUX_PKG_ESSENTIAL=yes

termux_step_pre_configure () {
	export TAR=tar # To make sure dpkg tries to use "tar" instead of e.g. "gnutar" (which happens when building on OS X)
        perl -p -i -e "s/TERMUX_ARCH/$TERMUX_ARCH/" $TERMUX_PKG_SRCDIR/configure
}
