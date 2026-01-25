TERMUX_PKG_HOMEPAGE=https://github.com/ubuntu-mate/mate-tweak
TERMUX_PKG_DESCRIPTION="Tweak tool for the MATE Desktop"
TERMUX_PKG_LICENSE="GPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="22.10.0"
TERMUX_PKG_SRCURL="https://github.com/ubuntu-mate/mate-tweak/archive/refs/tags/$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=c33c092b0151b50d8a5706825f1bcef57f1738f8f5cf22af49c11f45bc14e84a
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_PYTHON_RUNTIME_DEPS="distro, psutil, setproctitle"
TERMUX_PKG_DEPENDS="dconf, gsettings-desktop-schemas, ldd, libnotify, libmatekbd, mate-applets, mate-panel, pygobject, python, python-pip"
TERMUX_PKG_SUGGESTS="mate-applet-brisk-menu, plank-reloaded, tilda, mate-applet-appmenu"
TERMUX_PKG_BUILD_DEPENDS="rsync"
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_RM_AFTER_INSTALL="
local
share/polkit-1
"

termux_step_post_make_install() {
	# this software installs itself in a really messed-up directory structure.
	# The easiest way to explain what is wrong is to just show commands fixing it after installation:
	rsync -av "$TERMUX_PREFIX/local/bin/" "$TERMUX_PREFIX/bin"
	rsync -av "$TERMUX_PREFIX/local/lib/python$TERMUX_PYTHON_VERSION/dist-packages/usr/" "$TERMUX_PREFIX"
}
