TERMUX_PKG_HOMEPAGE=https://mate-desktop.org/
TERMUX_PKG_DESCRIPTION="Faenza icon theme for MATE"
TERMUX_PKG_LICENSE="GPL-3.0-only"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.20.0"
TERMUX_PKG_SRCURL="https://github.com/mate-desktop-legacy-archive/mate-icon-theme-faenza/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=3e838a08c18116d4d69fcacf50b456d79846db12bf249b44c7d971cf2df7b9c0
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE=newest-tag
TERMUX_PKG_BUILD_DEPENDS="mate-common"
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_host_build() {
	termux_download_ubuntu_packages mate-common
	sed -i "s|prefix=/usr|prefix=$TERMUX_PKG_HOSTBUILD_DIR/ubuntu_packages/usr|" \
		"$TERMUX_PKG_HOSTBUILD_DIR/ubuntu_packages/usr/bin/mate-doc-common"
}

termux_step_pre_configure() {
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "false" ]]; then
		export PATH="$TERMUX_PKG_HOSTBUILD_DIR/ubuntu_packages/usr/bin:$PATH"
	fi

	./autogen.sh
}
