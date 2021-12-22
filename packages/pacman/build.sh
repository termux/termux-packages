TERMUX_PKG_HOMEPAGE=https://archlinux.org/pacman/
TERMUX_PKG_DESCRIPTION="A library-based package manager with dependency support"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@Maxython"
TERMUX_PKG_VERSION=6.0.1
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://sources.archlinux.org/other/pacman/pacman-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=0db61456e56aa49e260e891c0b025be210319e62b15521f29d3e93b00d3bf731
TERMUX_PKG_DEPENDS="bash, libarchive, curl, gpgme"
TERMUX_PKG_BUILD_DEPENDS="doxygen, asciidoc, nettle"
TERMUX_PKG_GROUPS="base-devel"

# A temporary solution to the problem with compiling the documentation.
# https://github.com/termux/termux-packages/pull/7759#issuecomment-945664581
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Ddoc=disabled
"

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
	chmod 755 postinst
}
