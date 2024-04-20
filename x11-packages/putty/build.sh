TERMUX_PKG_HOMEPAGE=https://www.chiark.greenend.org.uk/~sgtatham/putty/
TERMUX_PKG_DESCRIPTION="A terminal integrated SSH/Telnet client"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.81"
TERMUX_PKG_SRCURL=https://the.earth.li/~sgtatham/putty/${TERMUX_PKG_VERSION}/putty-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=cb8b00a94f453494e345a3df281d7a3ed26bb0dd7e36264f145206f8857639fe
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="gdk-pixbuf, glib, gtk3, libcairo, libx11, pango"

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-glob"
}
