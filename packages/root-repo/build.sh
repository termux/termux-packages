TERMUX_PKG_HOMEPAGE=https://github.com/termux/termux-root-packages
TERMUX_PKG_DESCRIPTION="Package repository containing programs for rooted devices"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="Henrik Grimler @Grimler91"
TERMUX_PKG_VERSION=1.5
TERMUX_PKG_DEPENDS="termux-keyring"
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_make_install() {
	mkdir -p $TERMUX_PREFIX/etc/apt/sources.list.d
	echo "deb https://dl.bintray.com/grimler/termux-root-packages-21 root stable" > $TERMUX_PREFIX/etc/apt/sources.list.d/root.list
}

termux_step_create_debscripts() {
	echo "#!$TERMUX_PREFIX/bin/sh" > postinst
	echo "echo Downloading updated package list ..." >> postinst
	echo "apt update" >> postinst
	echo "exit 0" >> postinst
}
