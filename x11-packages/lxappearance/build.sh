TERMUX_PKG_HOMEPAGE=http://www.lxde.org/
TERMUX_PKG_DESCRIPTION="LXDE GTK+ theme switcher"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@Yisus7u7"
TERMUX_PKG_VERSION="0.6.4"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/lxde/lxappearance/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=9f067a8a126b9779ba12648c76136d9ba3e7ec7920c568df7819d128fdf39e03
TERMUX_PKG_DEPENDS="dbus-glib, gdk-pixbuf, glib, gtk3, libx11, xsltproc"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-gtk3 --enable-dbus"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_MAKE_PROCESSES=1
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"

termux_step_pre_configure() {
	autoreconf -fiv
}
