TERMUX_PKG_HOMEPAGE=https://github.com/termux/game-packages
TERMUX_PKG_DESCRIPTION="Package repository containing games for termux"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="Henrik Grimler @Grimler91"
TERMUX_PKG_VERSION=1.1
TERMUX_PKG_DEPENDS="termux-keyring"
TERMUX_PKG_PLATFORM_INDEPENDENT=yes

termux_step_make_install() {
	mkdir -p $TERMUX_PREFIX/etc/apt/sources.list.d
	echo "deb https://dl.bintray.com/grimler/game-packages-24 games stable" > $TERMUX_PREFIX/etc/apt/sources.list.d/game.list
}

termux_step_create_debscripts() {
	echo "#!$TERMUX_PREFIX/bin/sh" > postinst
	echo "echo Downloading updated package list ..." >> postinst
	echo "apt update" >> postinst
	echo "exit 0" >> postinst
}
