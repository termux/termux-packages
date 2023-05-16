TERMUX_PKG_HOMEPAGE=https://github.com/leo-arch/clifm
TERMUX_PKG_DESCRIPTION="The shell-like, command line terminal file manager: simple, fast, extensible, and lightweight as hell"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.12"
TERMUX_PKG_SRCURL=https://github.com/leo-arch/clifm/releases/download/v${TERMUX_PKG_VERSION}/clifm-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=a4cd97d7aa184a60e3e42ff33e6a31161818149c80caa92282cd2118e73319eb
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libcap, libacl, readline, file, libandroid-glob, libandroid-support"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS="-f misc/termux/Makefile"

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-glob"
}
