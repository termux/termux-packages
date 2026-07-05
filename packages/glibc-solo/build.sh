TERMUX_PKG_HOMEPAGE=https://github.com/termux/glibc-packages
# TERMUX_PKG_DESCRIPTION="A package repository containing glibc-based programs and libraries"
TERMUX_PKG_DESCRIPTION="glibc boot strap that replace glibc-repo"
TERMUX_PKG_LICENSE="WTFPL"
TERMUX_PKG_MAINTAINER="@termux-pacman"
TERMUX_PKG_VERSION=0
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_SKIP_SRC_EXTRACT=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_post_massage() {
	local target=etc/apt
	local source=$TERMUX_PKG_BUILDER_DIR
	mkdir -p $target
	cp $source/glibc.* $target/
	sed -i "s,@TERMUX_PREFIX@,$TERMUX_PREFIX," $target/*
}

termux_step_create_debscripts() {
	[ "$TERMUX_PACKAGE_FORMAT" = "pacman" ] && return 0
	cp -f "${TERMUX_PKG_BUILDER_DIR}/postinst" .
}
