TERMUX_PKG_HOMEPAGE=https://packages.debian.org/apt
TERMUX_PKG_DESCRIPTION="Front-end for the dpkg package manager"
TERMUX_PKG_DEPENDS="libcurl, liblzma, dpkg, gpgv, libc++, termux-exec"
TERMUX_PKG_VERSION=1.4.8
TERMUX_PKG_REVISION=5
TERMUX_PKG_SHA256=767ad7d6efb64cde52faececb7d3c0bf49800b9fe06f3a5b0132ab4c01a5b8f8
TERMUX_PKG_SRCURL=http://ftp.debian.org/debian/pool/main/a/apt/apt_${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DPERL_EXECUTABLE=`which perl`
-DCMAKE_INSTALL_FULL_LOCALSTATEDIR=$TERMUX_PREFIX
-DCOMMON_ARCH=$TERMUX_ARCH
-DDPKG_DATADIR=$TERMUX_PREFIX/share/dpkg
-DUSE_NLS=OFF
-DWITH_DOC=OFF
"
TERMUX_PKG_ESSENTIAL=yes
TERMUX_PKG_CONFFILES="etc/apt/sources.list etc/apt/trusted.gpg"
TERMUX_PKG_CONFLICTS=apt-transport-https
TERMUX_PKG_REPLACES=apt-transport-https
TERMUX_PKG_RM_AFTER_INSTALL="
bin/apt-cdrom
bin/apt-extracttemplates
bin/apt-sortpkgs
etc/apt/apt.conf.d
lib/apt/apt-helper
lib/apt/methods/bzip2
lib/apt/methods/cdrom
lib/apt/methods/mirror
lib/apt/methods/rred
lib/apt/planners/
lib/apt/solvers/
lib/dpkg/
lib/libapt-inst.so
"

termux_step_post_make_install() {
	printf "# The main termux repository:\ndeb https://termux.net stable main\n" > $TERMUX_PREFIX/etc/apt/sources.list
	cp $TERMUX_PKG_BUILDER_DIR/trusted.gpg $TERMUX_PREFIX/etc/apt/
	rm $TERMUX_PREFIX/include/apt-pkg -r
}
