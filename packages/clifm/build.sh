TERMUX_PKG_HOMEPAGE=https://github.com/leo-arch/clifm
TERMUX_PKG_DESCRIPTION="The shell-like, command line terminal file manager: simple, fast, extensible, and lightweight as hell"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.29"
TERMUX_PKG_SRCURL="https://github.com/leo-arch/clifm/releases/download/v${TERMUX_PKG_VERSION}/clifm-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=dfdc0f339437345d9d5d8c2cb4bd43294c05821ebc8d5f0c9abfa4eec8f6c905
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libcap, libacl, readline, libandroid-glob, libandroid-support, libmagic"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS="-f misc/termux/Makefile"

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-glob"
}
