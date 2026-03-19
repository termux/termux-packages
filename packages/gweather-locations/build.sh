TERMUX_PKG_HOMEPAGE="https://gitlab.gnome.org/GNOME/gweather-locations"
TERMUX_PKG_DESCRIPTION="The GWeather locations database"
TERMUX_PKG_LICENSE="GPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2026.2"
# https://download.gnome.org/sources/gweather-locations/${TERMUX_PKG_VERSION%.*}/gweather-locations-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SRCURL=https://gitlab.gnome.org/GNOME/gweather-locations/-/archive/${TERMUX_PKG_VERSION}/gweather-locations-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=b1c30d19279e8603ac1405f033ad4cd49d84e30828facfb73b77064aff088e15
TERMUX_PKG_BUILD_DEPENDS="gettext"
TERMUX_PKG_AUTO_UPDATE=true
