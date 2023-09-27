TERMUX_PKG_HOMEPAGE=https://github.com/termux-user-repository/tur
TERMUX_PKG_DESCRIPTION="A single and trusted place for all unofficial/less popular termux packages"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux-user-repository"
TERMUX_PKG_VERSION=1.0.1
TERMUX_PKG_SKIP_SRC_EXTRACT=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_make_install() {
	mkdir -p $TERMUX_PREFIX/etc/apt/sources.list.d
	echo "deb https://tur.kcubeterm.com tur-packages tur tur-on-device tur-continuous" > $TERMUX_PREFIX/etc/apt/sources.list.d/tur.list
	## tur gpg key
	mkdir -p $TERMUX_PREFIX/etc/apt/trusted.gpg.d
	install -Dm600 $TERMUX_PKG_BUILDER_DIR/tur.gpg $TERMUX_PREFIX/etc/apt/trusted.gpg.d/
}

termux_step_create_debscripts() {
	[ "$TERMUX_PACKAGE_FORMAT" = "pacman" ] && return 0
	echo "#!$TERMUX_PREFIX/bin/sh" > postinst
	echo "echo Downloading updated package list ..." >> postinst
	echo "apt update" >> postinst
	echo "exit 0" >> postinst
}
