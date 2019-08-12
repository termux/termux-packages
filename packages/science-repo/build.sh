TERMUX_PKG_HOMEPAGE=https://github.com/termux/science-packages
TERMUX_PKG_DESCRIPTION="Package repository containing science software"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="Henrik Grimler @Grimler91"
TERMUX_PKG_VERSION=1.0
TERMUX_PKG_DEPENDS="termux-keyring"
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_make_install() {
	mkdir -p $TERMUX_PREFIX/etc/apt/sources.list.d
	echo "deb https://dl.bintray.com/grimler/science-packages-24 science stable" > $TERMUX_PREFIX/etc/apt/sources.list.d/science.list
}

termux_step_create_debscripts() {
	echo "#!$TERMUX_PREFIX/bin/sh" > postinst
	echo "echo Downloading updated package list ..." >> postinst
	echo "apt update" >> postinst
	echo "exit 0" >> postinst
}
