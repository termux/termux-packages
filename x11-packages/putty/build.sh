TERMUX_PKG_HOMEPAGE=https://www.chiark.greenend.org.uk/~sgtatham/putty/
TERMUX_PKG_DESCRIPTION="A terminal integrated SSH/Telnet client"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.83"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://the.earth.li/~sgtatham/putty/${TERMUX_PKG_VERSION}/putty-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=718777c13d63d0dff91fe03162bc2a05b4dfc8b0827634cd60b51cefdff631c6
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="gdk-pixbuf, glib, gtk3, libcairo, libx11, pango"

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-glob"
}
