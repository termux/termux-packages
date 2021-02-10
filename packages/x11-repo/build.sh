TERMUX_PKG_HOMEPAGE=https://github.com/termux/x11-packages
TERMUX_PKG_DESCRIPTION="Package repository containing X11 programs and libraries"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="Leonid Pliushch <leonid.pliushch@gmail.com>"
TERMUX_PKG_VERSION=6.0
TERMUX_PKG_DEPENDS="termux-keyring"
TERMUX_PKG_SKIP_SRC_EXTRACT=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_make_install() {
	mkdir -p $TERMUX_PREFIX/etc/apt/sources.list.d
	echo "deb https://ipfs.io/ipns/k51qzi5uqu5dgu3homski160l4t4bmp52vb6dbgxb5bda90rewnwg64wnkwxj4 x11 main" > $TERMUX_PREFIX/etc/apt/sources.list.d/x11.list
}

termux_step_create_debscripts() {
	echo "#!$TERMUX_PREFIX/bin/sh" > postinst
	echo "echo Downloading updated package list ..." >> postinst
	echo "apt update" >> postinst
	echo "exit 0" >> postinst
}
