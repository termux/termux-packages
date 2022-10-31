TERMUX_PKG_HOMEPAGE=https://xorg.freedesktop.org/
TERMUX_PKG_DESCRIPTION="X.Org font utilities"
# Licenses: MIT, BSD 2-Clause, UCD
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="COPYING"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.3.3
TERMUX_PKG_SRCURL=https://xorg.freedesktop.org/releases/individual/font/font-util-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=e791c890779c40056ab63aaed5e031bb6e2890a98418ca09c534e6261a2eebd2

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--with-mapdir=${TERMUX_PREFIX}/share/fonts/util
--with-fontrootdir=${TERMUX_PREFIX}/share/fonts
"
