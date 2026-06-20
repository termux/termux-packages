TERMUX_PKG_HOMEPAGE=https://pwsafe.org/
TERMUX_PKG_DESCRIPTION="Popular secure and convenient password manager"
TERMUX_PKG_LICENSE="Artistic-License-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.72.0"
TERMUX_PKG_SRCURL="https://github.com/pwsafe/pwsafe/archive/refs/tags/$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=23f02e7b00deb184f114878e961c6975e04d6826f5b546098584c09b2143041a
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
