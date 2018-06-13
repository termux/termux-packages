TERMUX_PKG_HOMEPAGE=https://www.freedesktop.org/wiki/Software/fontconfig/
TERMUX_PKG_DESCRIPTION="Library for configuring and customizing font access"
TERMUX_PKG_VERSION=2.13.0
TERMUX_PKG_SHA256=91dde8492155b7f34bb95079e79be92f1df353fcc682c19be90762fd3e12eeb9
TERMUX_PKG_SRCURL=https://www.freedesktop.org/software/fontconfig/release/fontconfig-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_DEPENDS="freetype, libxml2, libpng, libuuid"
TERMUX_PKG_DEVPACKAGE_DEPENDS="freetype-dev, libxml2-dev"
# TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-libxml2
--enable-iconv=no
--disable-docs
--with-default-fonts=/system/fonts
--with-add-fonts=$TERMUX_PREFIX/share/fonts
"

termux_step_pre_configure() {
	# https://bugs.freedesktop.org/show_bug.cgi?id=101280
	rm src/fcobjshash.h
}
