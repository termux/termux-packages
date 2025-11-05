TERMUX_PKG_HOMEPAGE=https://www.freedesktop.org/wiki/Software/xdg-utils/
TERMUX_PKG_DESCRIPTION="A set of simple scripts that provide basic desktop integration functions for any Free Desktop"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.2.1"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://gitlab.freedesktop.org/xdg/xdg-utils/-/archive/v${TERMUX_PKG_VERSION}/xdg-utils-v${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=93d510dccf328378f012fe195b4574c2fac1cd65a74d0852d6eaa72e5a2065a7
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="desktop-file-utils, file, make, perl, shared-mime-info, which, xorg-xprop"
TERMUX_PKG_BUILD_IN_SRC=true

TERMUX_PKG_RM_AFTER_INSTALL="
bin/xdg-screensaver
share/man/man1/xdg-screensaver.1
"

termux_step_pre_configure() {
	# Certain packages are not safe to build on device because their
	# build.sh script deletes specific files in $TERMUX_PREFIX.
	if $TERMUX_ON_DEVICE_BUILD; then
		termux_error_exit "Package '$TERMUX_PKG_NAME' is not safe for on-device builds."
	fi
}

termux_step_post_make_install() {
	# `bin/xdg-open` conflicts with termux-tools.
	mv $TERMUX_PREFIX/bin/{,xdg-utils-}xdg-open
	mv $TERMUX_PREFIX/share/man/man1/{,xdg-utils-}xdg-open.1
}

termux_step_create_debscripts() {
	cat <<- POSTINST_EOF > ./postinst
	#!$TERMUX_PREFIX/bin/bash
	set -e

	echo "Sideloading Perl File::MimeInfo ..."
	cpan -Ti File::MimeInfo

	exit 0
	POSTINST_EOF
}
