TERMUX_PKG_HOMEPAGE='https://craigbarnes.gitlab.io/dte/'
TERMUX_PKG_DESCRIPTION='A small, configurable console text editor'
TERMUX_PKG_LICENSE='GPL-2.0'
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.10
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL="https://craigbarnes.gitlab.io/dist/dte/dte-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=db62aab235764f735adc8378f796d6474596582b7dae357e0bddf31304189800
TERMUX_PKG_DEPENDS="libandroid-support, libandroid-glob, libiconv"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	export LDLIBS="-landroid-support -landroid-glob -liconv"
}
