TERMUX_PKG_NAME="roshan"
TERMUX_PKG_HOMEPAGE="https://github.com/Roshan-Editor/Roshan-Editor"
TERMUX_PKG_DESCRIPTION="A tool to generate text banners"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@Roshan-Editor"
TERMUX_PKG_VERSION="5.0"
TERMUX_PKG_SRCURL="https://github.com/Roshan-Editor/Roshan-Editor.git"
TERMUX_PKG_GIT_BRANCH="main"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make_install() {
	mkdir -p $TERMUX_PKG_PREFIX/bin
	cp -a $TERMUX_PKG_SRCDIR/* $TERMUX_PKG_PREFIX/bin/
	chmod +x $TERMUX_PKG_PREFIX/bin/*
}
