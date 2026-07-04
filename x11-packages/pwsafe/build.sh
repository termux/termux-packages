TERMUX_PKG_HOMEPAGE=https://pwsafe.org/
TERMUX_PKG_DESCRIPTION="Popular secure and convenient password manager"
TERMUX_PKG_LICENSE="Artistic-License-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.72.1"
TERMUX_PKG_SRCURL="https://github.com/pwsafe/pwsafe/archive/refs/tags/$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=aa423e8e4f87872dbcfdd411614487a223b545ec41697551888652086ab50d4d
TERMUX_PKG_DEPENDS="file, libqrencode, wxwidgets, xerces-c"
TERMUX_PKG_AUTO_UPDATE=true
# -DHARDEN_USE_SAFE_STACK=ON causes Segmentation fault
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DHARDEN_USE_SAFE_STACK=OFF
-DNO_GTEST=ON
"

termux_step_pre_configure() {
	# bionic libc headers use 'PASSWORDLEN', which conflicts with pwsafe using it.
	find "$TERMUX_PKG_SRCDIR" -type f | \
		xargs -n 1 sed -i \
		-e 's|PASSWORDLEN|PASSWORDSAFELEN|g'
}
