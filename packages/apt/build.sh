TERMUX_PKG_HOMEPAGE=https://packages.debian.org/apt
TERMUX_PKG_DESCRIPTION="Front-end for the dpkg package manager"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=1.4.10
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=http://ftp.debian.org/debian/pool/main/a/apt/apt_${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=eaa314e8ebc9e62fedf316d196d1a99d894fd715e6385ed18afd41cc2cd5b127
# apt-key requires utilities from coreutils, findutils, gpgv, grep, sed.
TERMUX_PKG_DEPENDS="coreutils, dpkg, findutils, gpgv, grep, libc++, libcurl, liblzma, sed, termux-licenses, zlib"
TERMUX_PKG_CONFLICTS="apt-transport-https"
TERMUX_PKG_REPLACES="apt-transport-https"
TERMUX_PKG_RECOMMENDS="game-repo, science-repo"
TERMUX_PKG_SUGGESTS="gnupg"
TERMUX_PKG_ESSENTIAL=true

TERMUX_PKG_CONFFILES="
etc/apt/sources.list
"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DPERL_EXECUTABLE=$(which perl)
-DCMAKE_INSTALL_FULL_LOCALSTATEDIR=$TERMUX_PREFIX
-DCOMMON_ARCH=$TERMUX_ARCH
-DDPKG_DATADIR=$TERMUX_PREFIX/share/dpkg
-DUSE_NLS=OFF
-DWITH_DOC=OFF
"

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

termux_step_pre_configure() {
	# Certain packages are not safe to build on device because their
	# build.sh script deletes specific files in $TERMUX_PREFIX.
	if $TERMUX_ON_DEVICE_BUILD; then
		termux_error_exit "Package '$TERMUX_PKG_NAME' is not safe for on-device builds."
	fi
}

termux_step_post_make_install() {
	printf "# The main termux repository:\ndeb https://packages-cf.termux.dev/apt/termux-main-21 stable main\n" > $TERMUX_PREFIX/etc/apt/sources.list
	rm $TERMUX_PREFIX/include/apt-pkg -r

	# apt-transport-tor
	ln -sfr $TERMUX_PREFIX/lib/apt/methods/http $TERMUX_PREFIX/lib/apt/methods/tor
	ln -sfr $TERMUX_PREFIX/lib/apt/methods/http $TERMUX_PREFIX/lib/apt/methods/tor+http
	ln -sfr $TERMUX_PREFIX/lib/apt/methods/https $TERMUX_PREFIX/lib/apt/methods/tor+https

	# man pages
	mkdir -p $TERMUX_PREFIX/share/man/
	cp -Rf $TERMUX_PKG_BUILDER_DIR/man/* $TERMUX_PREFIX/share/man/
}
