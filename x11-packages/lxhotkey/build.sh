TERMUX_PKG_HOMEPAGE=https://github.com/lxde/lxhotkey
TERMUX_PKG_DESCRIPTION="Keyboard shortcuts configurator (part of LXDE)"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="JesusChapman <developer@jesuschapman.me>"
TERMUX_PKG_VERSION="0.1.2"
TERMUX_PKG_SRCURL=https://github.com/lxde/lxhotkey/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=f32686d298d86ae1e97c9e3d27ba1f01b6a0f17dbbbbd67dfbf82e7c0080c592
TERMUX_PKG_DEPENDS="glib, gtk3, libfm, libunistring, libx11"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-gtk=3"

termux_step_pre_configure() {
	./autogen.sh
}
