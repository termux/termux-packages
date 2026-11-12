TERMUX_PKG_HOMEPAGE=https://github.com/lxde/lxappearance-obconf
TERMUX_PKG_DESCRIPTION="Plugin for LXAppearance to configure Openbox"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="JesusChapman <developer@jesuschapman.me>"
TERMUX_PKG_VERSION="0.2.4"
TERMUX_PKG_SRCURL=https://github.com/lxde/lxappearance-obconf/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=202cede4e56d2f93b24dd945fcfa69d4cea62a8deae9bdd6e5d035edfe5c4df9
TERMUX_PKG_DEPENDS="gdk-pixbuf, glib, gtk3, libcairo, libx11, libxml2, lxappearance, openbox"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-gtk3"

termux_step_pre_configure() {
	./autogen.sh
}
