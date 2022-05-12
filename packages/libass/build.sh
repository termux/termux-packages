TERMUX_PKG_HOMEPAGE=https://github.com/libass/libass
TERMUX_PKG_DESCRIPTION="A portable library for SSA/ASS subtitles rendering"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.16.0"
TERMUX_PKG_SRCURL=https://github.com/libass/libass/releases/download/$TERMUX_PKG_VERSION/libass-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=5dbde9e22339119cf8eed59eea6c623a0746ef5a90b689e68a090109078e3c08
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="fontconfig, fribidi, glib, harfbuzz"
TERMUX_PKG_BREAKS="libass-dev"
TERMUX_PKG_REPLACES="libass-dev"
# Avoid text relocations.
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" ac_cv_prog_nasm_check=no"
