TERMUX_PKG_HOMEPAGE=https://archlinux.org/pacman/
TERMUX_PKG_DESCRIPTION="A library-based package manager with dependency support"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@Maxython <mixython@gmail.com>"
TERMUX_PKG_VERSION=6.0.2
TERMUX_PKG_REVISION=4
TERMUX_PKG_SRCURL=https://sources.archlinux.org/other/pacman/pacman-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=7d8e3e8c5121aec0965df71f59bedf46052c6cf14f96365c4411ec3de0a4c1a5
TERMUX_PKG_DEPENDS="bash, libarchive, curl, gpgme, openssl, termux-licenses"
TERMUX_PKG_BUILD_DEPENDS="doxygen, asciidoc, nettle"
TERMUX_PKG_RECOMMENDS="termux-keyring"
TERMUX_PKG_GROUPS="base-devel"
TERMUX_PKG_CONFFILES="etc/pacman.conf, etc/makepkg.conf, var/log/pacman.log"

termux_step_pre_configure() {
	rm -f ./scripts/libmakepkg/executable/sudo.sh.in
	rm -f ./scripts/libmakepkg/executable/fakeroot.sh.in

	sed -i "s/Architecture = auto/Architecture = ${TERMUX_ARCH}/" ./etc/pacman.conf.in
}

termux_step_post_configure() {
	sed -i 's/$ARGS -o $out $in $LINK_ARGS/$ARGS -o $out $in $LINK_ARGS -landroid-glob/' ${TERMUX_TOPDIR}/pacman/build/build.ninja
}

termux_step_create_debscripts() {
	echo "#!$TERMUX_PREFIX/bin/bash" > postinst
	echo "mkdir -p $TERMUX_PREFIX/var/lib/pacman/sync" >> postinst
	echo "mkdir -p $TERMUX_PREFIX/var/lib/pacman/local" >> postinst
	echo "mkdir -p $TERMUX_PREFIX/var/cache/pacman/pkg" >> postinst
	chmod 755 postinst
}
