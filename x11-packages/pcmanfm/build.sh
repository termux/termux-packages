TERMUX_PKG_HOMEPAGE=https://sourceforge.net/projects/pcmanfm/
TERMUX_PKG_DESCRIPTION="Extremely fast and lightweight file manager"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Leonid Pliushch <leonid.pliushch@gmail.com>"
TERMUX_PKG_VERSION=1.3.2
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/pcmanfm/pcmanfm-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=14cb7b247493c4cce65fbb5902611e3ad00a7a870fbc1e50adc50428c5140cf7
TERMUX_PKG_DEPENDS="atk, glib, gtk3, libandroid-shmem, libcairo, libfm, libx11, lxmenu-data, pango"
TERMUX_PKG_RECOMMENDS="xarchiver"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--with-gtk=3
"

termux_step_pre_configure() {
    export LIBS="-landroid-shmem"
}
