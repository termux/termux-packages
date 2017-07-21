TERMUX_PKG_HOMEPAGE=https://packages.debian.org/apt
TERMUX_PKG_DESCRIPTION="Front-end for the dpkg package manager"
TERMUX_PKG_DEPENDS="libbz2, liblzma, dpkg, gpgv, libc++"
TERMUX_PKG_VERSION=1.4.7
TERMUX_PKG_SRCURL=http://ftp.debian.org/debian/pool/main/a/apt/apt_${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=ea2a2e8e08daf8ea11aeaa86928d943a42ce53989165a30cc828838d470b7719
TERMUX_PKG_EXTRA_CONFIGURE_ARGS=" -DCOMMON_ARCH=$TERMUX_ARCH -DUSE_NLS=OFF -DDPKG_DATADIR=$TERMUX_PREFIX/share/dpkg -DCMAKE_INSTALL_FULL_LOCALSTATEDIR=$TERMUX_PREFIX"
TERMUX_PKG_FOLDERNAME=apt-${TERMUX_PKG_VERSION}
TERMUX_PKG_ESSENTIAL=yes
TERMUX_PKG_CONFFILES="etc/apt/sources.list"
termux_step_pre_configure () {
	LDFLAGS+=" -landroid-glob"
}
termux_step_post_make_install() {
	printf "# The main termux repository:\ndeb [arch=all,${TERMUX_ARCH}] http://termux.net stable main\n" > $TERMUX_PREFIX/etc/apt/sources.list
        cp $TERMUX_PKG_BUILDER_DIR/trusted.gpg $TERMUX_PREFIX/etc/apt/
	rm /data/data/com.termux/files/usr/include/apt-pkg -r
}
