TERMUX_PKG_HOMEPAGE=https://invisible-island.net/luit/
TERMUX_PKG_DESCRIPTION="Locale and ISO 2022 support for Unicode terminals"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=20230201
TERMUX_PKG_SRCURL=https://invisible-island.net/archives/luit/luit-${TERMUX_PKG_VERSION}.tgz
TERMUX_PKG_SHA256=ee2a8d1dbc7ee23d00c412a1f0b3d70678514d56d5be0a816dd95e232e76c56f
TERMUX_PKG_DEPENDS="libiconv, zlib"
TERMUX_PKG_CONFLICTS="xorg-luit"
TERMUX_PKG_REPLACES="xorg-luit"
TERMUX_PKG_PROVIDES="xorg-luit"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
cf_cv_working_poll=yes
--with-locale-alias=$TERMUX_PREFIX/share/X11/locale/locale.alias
"
