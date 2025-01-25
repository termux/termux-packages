TERMUX_PKG_HOMEPAGE=https://archlinux.org/pacman/
TERMUX_PKG_DESCRIPTION="A library-based package manager with dependency support"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@Maxython <mixython@gmail.com>"
TERMUX_PKG_VERSION=7.0.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://gitlab.archlinux.org/pacman/pacman/-/releases/v${TERMUX_PKG_VERSION}/downloads/pacman-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=61cbd445d1381b4b184bc7c4e2791f07a79f0f2807b7c600399d0d08e8cd28cf
TERMUX_PKG_DEPENDS="bash, curl, gpgme, libandroid-glob, libarchive, libcurl, openssl, termux-licenses, termux-keyring"
TERMUX_PKG_BUILD_DEPENDS="doxygen, asciidoc, nettle"
TERMUX_PKG_GROUPS="base-devel"
TERMUX_PKG_CONFFILES="etc/pacman.conf, etc/pacman.d/serverlist, etc/makepkg.conf, var/log/pacman.log"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--prefix=${TERMUX_PREFIX}
--sysconfdir=${TERMUX_PREFIX}/etc
--localstatedir=${TERMUX_PREFIX}/var
-Dpkg-ext=.pkg.tar.xz
-Dscriptlet-shell=${TERMUX_PREFIX}/bin/bash
-Dmakepkg-template-dir=${TERMUX_PREFIX}/share/makepkg-template
-Di18n=false
"

termux_step_pre_configure() {
	rm -f ./scripts/libmakepkg/executable/sudo.sh.in
	rm -f ./scripts/libmakepkg/executable/fakeroot.sh.in

	sed -i "s/@TERMUX_ARCH@/${TERMUX_ARCH}/" ./etc/{pacman,makepkg}.conf.in
}

termux_step_post_configure() {
	sed -i 's/$ARGS -o $out $in $LINK_ARGS/$ARGS -o $out $in $LINK_ARGS -landroid-glob/' ${TERMUX_PKG_BUILDDIR}/build.ninja
}

termux_step_post_make_install() {
	mkdir -p $TERMUX_PREFIX/etc/pacman.d
	{
		echo '# Official services Termux-Pacman'
		echo
		echo '# US'
		echo 'Server = https://service.termux-pacman.dev/$repo/$arch'
		echo 'Server = https://s3.amazonaws.com/termux-pacman.us/$repo/$arch'
	} > $TERMUX_PREFIX/etc/pacman.d/serverlist
}

termux_step_create_debscripts() {
	echo "#!$TERMUX_PREFIX/bin/bash" > postinst
	echo "mkdir -p $TERMUX_PREFIX/var/lib/pacman/sync" >> postinst
	echo "mkdir -p $TERMUX_PREFIX/var/lib/pacman/local" >> postinst
	echo "mkdir -p $TERMUX_PREFIX/var/cache/pacman/pkg" >> postinst
	chmod 755 postinst
}
