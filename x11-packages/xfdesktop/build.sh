TERMUX_PKG_HOMEPAGE=https://www.xfce.org/
TERMUX_PKG_DESCRIPTION="A desktop manager for XFCE environment"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Leonid Pliushch <leonid.pliushch@gmail.com>"
TERMUX_PKG_VERSION=4.15.1
TERMUX_PKG_SRCURL=https://gitlab.xfce.org/xfce/xfdesktop/-/archive/xfdesktop-${TERMUX_PKG_VERSION}/xfdesktop-xfdesktop-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=a0ba26b44e7a2e55369bb01aea9b0abe4848f493b4c7807363f6bb640c69126a
TERMUX_PKG_DEPENDS="exo, garcon, hicolor-icon-theme, libwnck, libxfce4ui, startup-notification, thunar"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-notifications --enable-maintainer-mode"

termux_step_pre_configure() {
	NOCONFIGURE=1 ./autogen.sh
}
