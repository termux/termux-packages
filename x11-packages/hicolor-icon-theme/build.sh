TERMUX_PKG_HOMEPAGE=https://www.freedesktop.org/wiki/Software/icon-theme/
TERMUX_PKG_DESCRIPTION="Freedesktop.org Hicolor icon theme"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.17
TERMUX_PKG_REVISION=29
TERMUX_PKG_SRCURL=https://gitlab.freedesktop.org/xdg/default-icon-theme/-/archive/${TERMUX_PKG_VERSION}/default-icon-theme-master.tar.gz
TERMUX_PKG_SHA256=a0bd3e5a3b0c109a2ccb5aa2d150c3b8a485de532f674c5fe3ffd18e97cf17cd
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	./autogen.sh
}
