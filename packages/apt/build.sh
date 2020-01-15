TERMUX_PKG_HOMEPAGE=https://packages.debian.org/apt
TERMUX_PKG_DESCRIPTION="Front-end for the dpkg package manager"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=1.4.9
TERMUX_PKG_REVISION=25
TERMUX_PKG_SRCURL=http://ftp.debian.org/debian/pool/main/a/apt/apt_${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=d4d65e7c84da86f3e6dcc933bba46a08db429c9d933b667c864f5c0e880bac0d
# apt-key requires utilities from coreutils, findutils, gpgv, grep, sed.
TERMUX_PKG_DEPENDS="coreutils, dpkg, findutils, gpgv, grep, libc++, libcurl, liblzma, sed, termux-licenses, zlib"
TERMUX_PKG_CONFLICTS="apt-transport-https, libapt-pkg"
TERMUX_PKG_REPLACES="apt-transport-https, libapt-pkg"
TERMUX_PKG_RECOMMENDS="game-repo, science-repo"
TERMUX_PKG_SUGGESTS="gnupg, unstable-repo, x11-repo"
TERMUX_PKG_ESSENTIAL=true

TERMUX_PKG_CONFFILES="
etc/apt/sources.list
etc/apt/trusted.gpg
"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DPERL_EXECUTABLE=$(which perl)
-DCMAKE_INSTALL_FULL_LOCALSTATEDIR=$TERMUX_PREFIX
-DCOMMON_ARCH=$TERMUX_ARCH
-DDPKG_DATADIR=$TERMUX_PREFIX/share/dpkg
-DUSE_NLS=OFF
-DWITH_DOC=OFF
"

# ubuntu uses instead $PREFIX/lib instead of $PREFIX/libexec to
# "Work around bug in GNUInstallDirs" (from apt 1.4.8 CMakeLists.txt).
# Archlinux uses $PREFIX/libexec though, so let's force libexec->lib to
# get same build result on ubuntu and archlinux.
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+="-DCMAKE_INSTALL_LIBEXECDIR=lib"

TERMUX_PKG_RM_AFTER_INSTALL="
bin/apt-cdrom
bin/apt-extracttemplates
bin/apt-sortpkgs
etc/apt/apt.conf.d
lib/apt/methods/bzip2
lib/apt/methods/cdrom
lib/apt/methods/mirror
lib/apt/methods/rred
lib/apt/planners/
lib/apt/solvers/
lib/dpkg/
"

termux_step_pre_configure() {
	# Certain packages are not safe to build on device because their
	# build.sh script deletes specific files in $TERMUX_PREFIX.
	if $TERMUX_ON_DEVICE_BUILD; then
		termux_error_exit "Package '$TERMUX_PKG_NAME' is not safe for on-device builds."
	fi
}

termux_step_post_make_install() {
	printf "# The main termux repository:\ndeb https://termux.org/packages/ stable main\n" > $TERMUX_PREFIX/etc/apt/sources.list
	cp $TERMUX_PKG_BUILDER_DIR/trusted.gpg $TERMUX_PREFIX/etc/apt/

	# apt-transport-tor
	ln -sfr $TERMUX_PREFIX/lib/apt/methods/http $TERMUX_PREFIX/lib/apt/methods/tor
	ln -sfr $TERMUX_PREFIX/lib/apt/methods/http $TERMUX_PREFIX/lib/apt/methods/tor+http
	ln -sfr $TERMUX_PREFIX/lib/apt/methods/https $TERMUX_PREFIX/lib/apt/methods/tor+https

	# man pages
	mkdir -p $TERMUX_PREFIX/share/man/
	cp -Rf $TERMUX_PKG_BUILDER_DIR/man/* $TERMUX_PREFIX/share/man/
}
