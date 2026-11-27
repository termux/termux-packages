TERMUX_PKG_HOMEPAGE=https://github.com/altdesktop/playerctl
TERMUX_PKG_DESCRIPTION="MPRIS command-line controller and library"
TERMUX_PKG_LICENSE="LGPL-3.0"
TERMUX_PKG_MAINTAINER="@Keytaro2"
TERMUX_PKG_VERSION="2.4.1"
TERMUX_PKG_SRCURL="https://github.com/altdesktop/playerctl/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=75957ad5071956f563542c7557af16a57e40b4a7f66bc9b6373d022ec5eef548
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="glib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dintrospection=false
-Dgtk-doc=false
-Dbash-completions=true
-Dzsh-completions=true
"
