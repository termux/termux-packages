TERMUX_PKG_HOMEPAGE=https://github.com/termux/nonfree-packages
TERMUX_PKG_DESCRIPTION="Package repository containing software licensed under non-free/custom licenses."
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com> @xeffyr"
TERMUX_PKG_VERSION=1.0
TERMUX_PKG_DEPENDS="termux-keyring"
TERMUX_PKG_PLATFORM_INDEPENDENT=yes

termux_step_make_install() {
	mkdir -p $TERMUX_PREFIX/etc/apt/sources.list.d
	echo "deb https://termux.com/nonfree-packages stable main" > $TERMUX_PREFIX/etc/apt/sources.list.d/nonfree.list
}

termux_step_create_debscripts() {
	echo "#!$TERMUX_PREFIX/bin/sh" > postinst
	echo "echo Downloading updated package list ..." >> postinst
	echo "apt update" >> postinst
	echo "exit 0" >> postinst
}
