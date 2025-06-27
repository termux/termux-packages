TERMUX_PKG_HOMEPAGE=https://micro-editor.github.io/
TERMUX_PKG_DESCRIPTION="Modern and intuitive terminal-based text editor"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.0.14"
TERMUX_PKG_REVISION=2
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="latest-release-tag"
TERMUX_PKG_SRCURL=git+https://github.com/zyedidia/micro

termux_step_make() {
	return
}

termux_step_make_install() {
	termux_setup_golang

	export GOPATH=$TERMUX_PKG_BUILDDIR
	local MICRO_SRC=$GOPATH/src/github.com/zyedidia/micro

	cd "$TERMUX_PKG_SRCDIR"
	mkdir -p "$MICRO_SRC"
	cp -R . "$MICRO_SRC"

	cd "$MICRO_SRC"
	sed -zEi 's/VERSION = \$\(.+\\\n.+\)/VERSION = '"$TERMUX_PKG_VERSION"'/gm' Makefile
	make build
	mv micro "$TERMUX_PREFIX/bin/micro"
}
