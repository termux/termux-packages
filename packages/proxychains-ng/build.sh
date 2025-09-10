TERMUX_PKG_HOMEPAGE=https://github.com/rofl0r/proxychains-ng
TERMUX_PKG_DESCRIPTION="A hook preloader that allows to redirect TCP traffic of existing dynamically linked programs through one or more SOCKS or HTTP proxies"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=4.17
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/rofl0r/proxychains-ng/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=1a2dc68fcbcb2546a07a915343c1ffc75845f5d9cc3ea5eb3bf0b62a66c0196f
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	# Certain packages are not safe to build on device because their
	# build.sh script deletes specific files in $TERMUX_PREFIX.
	if $TERMUX_ON_DEVICE_BUILD; then
		termux_error_exit "Package '$TERMUX_PKG_NAME' is not safe for on-device builds."
	fi
}

termux_step_post_make_install() {
	# Remove conf file from previous build, otherwise nothing will be done and it won't be included in the package
	rm -f "$TERMUX_PREFIX"/etc/proxychains.conf
	make install-config
}
