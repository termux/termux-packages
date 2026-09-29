TERMUX_PKG_HOMEPAGE=https://mate-desktop.org/
TERMUX_PKG_DESCRIPTION="MATE default icon theme"
TERMUX_PKG_LICENSE="GPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.28.0"
TERMUX_PKG_SRCURL="https://github.com/mate-desktop/mate-icon-theme/releases/download/v$TERMUX_PKG_VERSION/mate-icon-theme-$TERMUX_PKG_VERSION.tar.xz"
TERMUX_PKG_SHA256=94d6079060ca5df74542921de4eea38b7d02d07561c919356d95de876f9a6d3a
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_DEPENDS="mate-common, icon-naming-utils"
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_HOSTBUILD=true

termux_step_host_build() {
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "true" ]]; then
		return
	fi
	# XML::Simple for running $TERMUX_PREFIX/libexec/icon-name-mapping in
	# the Ubuntu termux-package-builder's perl during cross-compilation
	termux_download_ubuntu_packages libxml-simple-perl
}

termux_step_pre_configure() {
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "false" ]]; then
		export PERL5LIB="$TERMUX_PKG_HOSTBUILD_DIR/ubuntu_packages/usr/share/perl5"
	fi
}
