TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com> @xeffyr"

TERMUX_PKG_HOMEPAGE=https://termux-x11.ml
TERMUX_PKG_DESCRIPTION="Package repository containing X11 programs and libraries (testing)"
TERMUX_PKG_VERSION=1.0
TERMUX_PKG_PLATFORM_INDEPENDENT=yes
TERMUX_PKG_DEPENDS="x11-repo"

termux_step_make_install() {
    mkdir -p $TERMUX_PREFIX/etc/apt/sources.list.d
    echo "deb https://termux-x11.ml x11 testing" > $TERMUX_PREFIX/etc/apt/sources.list.d/x11-testing.list
}

termux_step_create_debscripts() {
    {
	    echo "#!$TERMUX_PREFIX/bin/sh"
	    echo "echo Downloading updated package list ..."
	    echo "apt update"
	    echo "exit 0"
    } > postinst
}
