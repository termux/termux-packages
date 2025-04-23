TERMUX_PKG_HOMEPAGE=https://packages.debian.org/apt
TERMUX_PKG_DESCRIPTION="Front-end for the dpkg package manager"
TERMUX_PKG_LICENSE="BSD 3-Clause, GPL-2.0-only, GPL-2.0-or-later, MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.1.5"
# old tarball are removed in https://deb.debian.org/debian/pool/main/a/apt/apt_${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SRCURL=https://salsa.debian.org/apt-team/apt/-/archive/${TERMUX_PKG_VERSION}/apt-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=5f0c91ca278f2386121d425492d34f28cb20d08b131e03cf00ca6935e1797987
# apt-key requires utilities from coreutils, findutils, gpgv, grep, sed.
TERMUX_PKG_DEPENDS="coreutils, dpkg, findutils, grep, libandroid-glob, libbz2, libc++, libiconv, liblz4, liblzma, libseccomp, openssl, sed, sequoia-sqv | gpgv, termux-keyring, termux-licenses, xxhash, zlib, zstd"
TERMUX_PKG_BUILD_DEPENDS="docbook-xsl, libdb, gnupg, sequoia-sqv"
TERMUX_PKG_CONFLICTS="apt-transport-https, libapt-pkg, unstable-repo, game-repo, science-repo"
TERMUX_PKG_REPLACES="apt-transport-https, libapt-pkg, unstable-repo, game-repo, science-repo"
TERMUX_PKG_PROVIDES="unstable-repo, game-repo, science-repo"
TERMUX_PKG_SUGGESTS="gnupg, less"
TERMUX_PKG_ESSENTIAL=true

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_POLICY_VERSION_MINIMUM=3.5
-DPERL_EXECUTABLE=$(command -v perl)
-DCMAKE_INSTALL_FULL_LOCALSTATEDIR=$TERMUX_PREFIX
-DCACHE_DIR=${TERMUX_CACHE_DIR}/apt
-DCOMMON_ARCH=$TERMUX_ARCH
-DDPKG_DATADIR=$TERMUX_PREFIX/share/dpkg
-DUSE_NLS=OFF
-DWITH_DOC=OFF
-DWITH_DOC_MANPAGES=ON
-DDEFAULT_PAGER=$TERMUX_PREFIX/bin/less
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

TERMUX_PKG_ON_DEVICE_BUILD_NOT_SUPPORTED=true

termux_step_pre_configure() {
	# Fix i686 builds.
	CXXFLAGS+=" -Wno-c++11-narrowing"
	# Fix glob() on Android 7.
	LDFLAGS+=" -Wl,--no-as-needed -landroid-glob"

	# for manpage build
	local docbook_xsl_version
	docbook_xsl_version=$(. "$TERMUX_SCRIPTDIR/packages/docbook-xsl/build.sh"; echo "$TERMUX_PKG_VERSION")
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DDOCBOOK_XSL=$TERMUX_PREFIX/share/xml/docbook/xsl-stylesheets-$docbook_xsl_version-nons"
}

termux_step_post_make_install() {
	mkdir -p "$TERMUX_PREFIX/etc/apt/sources.list.d"
	{ # write deb822 source entries for the main repo
	printf '%s\n' \
		"# The main termux repository, with cloudflare cache" \
		"Types: deb" \
		"URIs: https://packages-cf.termux.dev/apt/termux-main/" \
		"Suites: stable" \
		"Components: main" \
		"Signed-By: $TERMUX_PREFIX/etc/apt/trusted.gpg.d/grimler.gpg, $TERMUX_PREFIX/etc/apt/trusted.gpg.d/termux-autobuilds.gpg" \
		"" \
		"# The main termux repository, without cloudflare cache" \
		"#Types: deb" \
		"#URIs: https://packages-cf.termux.dev/apt/termux-main/" \
		"#Suites: stable" \
		"#Components: main" \
		"#Signed-By: $TERMUX_PREFIX/etc/apt/trusted.gpg.d/grimler.gpg, $TERMUX_PREFIX/etc/apt/trusted.gpg.d/termux-autobuilds.gpg"
	} > "$TERMUX_PREFIX/etc/apt/sources.list.d/main.sources"

	# apt-transport-tor
	ln -sfr "$TERMUX_PREFIX/lib/apt/methods/http"  "$TERMUX_PREFIX/lib/apt/methods/tor"
	ln -sfr "$TERMUX_PREFIX/lib/apt/methods/http"  "$TERMUX_PREFIX/lib/apt/methods/tor+http"
	ln -sfr "$TERMUX_PREFIX/lib/apt/methods/https" "$TERMUX_PREFIX/lib/apt/methods/tor+https"
	# Workaround for "empty" subpackage:
	local dir="$TERMUX_PREFIX/share/apt-transport-tor"
	mkdir -p "$dir"
	touch "$dir/.placeholder"

	sed -e "s|@TERMUX_PREFIX@|${TERMUX_PREFIX}|g" \
		-e "s|@TERMUX_ARCH@|${TERMUX_ARCH}|g" \
		"$TERMUX_SCRIPTDIR/packages/apt/emergency-restore.sh.in" > "$TERMUX_PREFIX/bin/apt-emergency-restore"
}

termux_step_create_debscripts() {
	[[ "$TERMUX_PACKAGE_FORMAT" == 'pacman' ]] && return 0

	local REPO="main"
	local LEGACY_SOURCES="sources.list" # Note that this is not in sources.list.d/
	sed -e "s|@LEGACY_SOURCES@|$LEGACY_SOURCES|g" \
		-e "s|@TERMUX_PREFIX@|$TERMUX_PREFIX|g" \
		-e "s|@REPO@|$REPO|g" \
		"$TERMUX_SCRIPTDIR/packages/apt/preinst.sh.in" > ./preinst

	sed -e "s|@LEGACY_SOURCES@|$LEGACY_SOURCES|g" \
		-e "s|@TERMUX_PREFIX@|$TERMUX_PREFIX|g" \
		-e "s|@REPO@|$REPO|g" \
		"$TERMUX_SCRIPTDIR/packages/apt/postinst.sh.in" > ./postinst

	chmod +x ./preinst ./postinst
}
