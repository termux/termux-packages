TERMUX_PKG_HOMEPAGE=https://pwsafe.org/
TERMUX_PKG_DESCRIPTION="Popular secure and convenient password manager"
TERMUX_PKG_LICENSE="Artistic-License-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.24.0"
TERMUX_PKG_SRCURL="https://github.com/pwsafe/pwsafe/archive/refs/tags/$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=234f88f7c224c9dcaea5650afca5957fcf3f80ea411d92a34f26468e7ecd0485
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
