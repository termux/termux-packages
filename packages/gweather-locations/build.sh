TERMUX_PKG_HOMEPAGE="https://gitlab.gnome.org/GNOME/gweather-locations"
TERMUX_PKG_DESCRIPTION="The GWeather locations database"
TERMUX_PKG_LICENSE="GPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2026.1"
# https://download.gnome.org/sources/gweather-locations/${TERMUX_PKG_VERSION%.*}/gweather-locations-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SRCURL=https://gitlab.gnome.org/GNOME/gweather-locations/-/archive/${TERMUX_PKG_VERSION}/gweather-locations-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=4f481a098f95c6a725b7d1729dec0bb873a387dfed36f7bfd5bd3e8f5e023dfc
TERMUX_PKG_BUILD_DEPENDS="gettext"
TERMUX_PKG_AUTO_UPDATE=true
