TERMUX_PKG_HOMEPAGE=https://github.com/termux/unstable-packages
TERMUX_PKG_DESCRIPTION="Package repository containing new/unstable programs and libraries."
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
TERMUX_PKG_VERSION=2.0
TERMUX_PKG_DEPENDS="termux-keyring"
TERMUX_PKG_PLATFORM_INDEPENDENT=yes

termux_step_make_install() {
	mkdir -p $TERMUX_PREFIX/etc/apt/sources.list.d
	echo "deb https://dl.bintray.com/xeffyr/unstable-packages-24 unstable main" > $TERMUX_PREFIX/etc/apt/sources.list.d/unstable.list
}

termux_step_create_debscripts() {
	echo "#!$TERMUX_PREFIX/bin/sh" > postinst
	echo "echo Downloading updated package list ..." >> postinst
	echo "apt update" >> postinst
	echo "exit 0" >> postinst
}
