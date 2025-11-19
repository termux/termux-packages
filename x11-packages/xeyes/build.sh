TERMUX_PKG_HOMEPAGE=https://gitlab.freedesktop.org/xorg/app/xeyes
TERMUX_PKG_DESCRIPTION="A follow the mouse X demo"
TERMUX_PKG_LICENSE="X11"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.3.1
TERMUX_PKG_SRCURL=https://gitlab.freedesktop.org/xorg/app/xeyes/-/archive/xeyes-${TERMUX_PKG_VERSION}/xeyes-xeyes-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=6ba53dbe17ff644c325dc28a7faab5125dd6b8d780d3709b874180c5dfd9cbb2
TERMUX_PKG_DEPENDS="libx11, libxcb, libxext, libxi, libxmu, libxrender, libxt"
TERMUX_PKG_BUILD_DEPENDS="libxfixes, xorg-util-macros"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	autoreconf -fi
}
