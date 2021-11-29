TERMUX_PKG_HOMEPAGE=https://packages.debian.org/apt
TERMUX_PKG_DESCRIPTION="Front-end for the dpkg package manager"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.3.13
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://deb.debian.org/debian/pool/main/a/apt/apt_${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=e519e55f1015d656425e68f8c7c7bebd1908df3ac87836eb6e7b6b58ce3f965d
# apt-key requires utilities from coreutils, findutils, gpgv, grep, sed.
TERMUX_PKG_DEPENDS="coreutils, dpkg, findutils, gpgv, grep, libandroid-glob, libbz2, libc++, libcurl, libgnutls, liblz4, liblzma, sed, termux-licenses, xxhash, zlib"
TERMUX_PKG_BUILD_DEPENDS="docbook-xsl"
TERMUX_PKG_CONFLICTS="apt-transport-https, libapt-pkg"
TERMUX_PKG_REPLACES="apt-transport-https, libapt-pkg, unstable-repo"
TERMUX_PKG_PROVIDES="unstable-repo, game-repo"
TERMUX_PKG_RECOMMENDS="science-repo"
TERMUX_PKG_SUGGESTS="gnupg, x11-repo"
TERMUX_PKG_ESSENTIAL=true

TERMUX_PKG_CONFFILES="
etc/apt/sources.list
etc/apt/trusted.gpg
"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DPERL_EXECUTABLE=$(command -v perl)
-DCMAKE_INSTALL_FULL_LOCALSTATEDIR=$TERMUX_PREFIX
-DCACHE_DIR=${TERMUX_CACHE_DIR}/apt
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
lib/apt/methods/cdrom
lib/apt/methods/mirror*
lib/apt/methods/rred
lib/apt/planners/
lib/apt/solvers/
lib/dpkg/
share/man/man1/apt-extracttemplates.1
share/man/man1/apt-sortpkgs.1
share/man/man1/apt-transport-mirror.1
share/man/man8/apt-cdrom.8
"

termux_step_pre_configure() {
	# Certain packages are not safe to build on device because their
	# build.sh script deletes specific files in $TERMUX_PREFIX.
	if $TERMUX_ON_DEVICE_BUILD; then
		termux_error_exit "Package '$TERMUX_PKG_NAME' is not safe for on-device builds."
	fi

	# Fix i686 builds.
	CXXFLAGS+=" -Wno-c++11-narrowing"
	# Fix glob() on Android 7.
	LDFLAGS+=" -Wl,--no-as-needed -landroid-glob"

	# for manpage build
	local docbook_xsl_version=$(. $TERMUX_SCRIPTDIR/packages/docbook-xsl/build.sh; echo $TERMUX_PKG_VERSION)
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DDOCBOOK_XSL=$TERMUX_PREFIX/share/xml/docbook/xsl-stylesheets-$docbook_xsl_version-nons"
}

termux_step_post_make_install() {
	printf "# The main termux repository:\ndeb https://packages.termux.org/apt/termux-main/ stable main\n" > $TERMUX_PREFIX/etc/apt/sources.list
	cp $TERMUX_PKG_BUILDER_DIR/trusted.gpg $TERMUX_PREFIX/etc/apt/

	# apt-transport-tor
	ln -sfr $TERMUX_PREFIX/lib/apt/methods/http $TERMUX_PREFIX/lib/apt/methods/tor
	ln -sfr $TERMUX_PREFIX/lib/apt/methods/http $TERMUX_PREFIX/lib/apt/methods/tor+http
	ln -sfr $TERMUX_PREFIX/lib/apt/methods/https $TERMUX_PREFIX/lib/apt/methods/tor+https
}
