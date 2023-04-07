TERMUX_PKG_HOMEPAGE='https://craigbarnes.gitlab.io/dte/'
TERMUX_PKG_DESCRIPTION='A small, configurable console text editor'
TERMUX_PKG_LICENSE='GPL-2.0'
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.11.1"
TERMUX_PKG_SRCURL=https://gitlab.com/craigbarnes/dte/-/archive/v${TERMUX_PKG_VERSION}/dte-v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=68c25bc4e8792da33529626e23102cd5fb34186479049f5480fd9f3e9ffb1171
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libandroid-support, libandroid-glob, libiconv"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	export LDLIBS="-landroid-support -landroid-glob -liconv"
}
