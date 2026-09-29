TERMUX_PKG_HOMEPAGE=https://github.com/ubuntu-mate/mate-tweak
TERMUX_PKG_DESCRIPTION="Tweak tool for the MATE Desktop"
TERMUX_PKG_LICENSE="GPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="22.10.0"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL="https://github.com/ubuntu-mate/mate-tweak/archive/refs/tags/$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=c33c092b0151b50d8a5706825f1bcef57f1738f8f5cf22af49c11f45bc14e84a
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_PYTHON_RUNTIME_DEPS="distro, setproctitle"
TERMUX_PKG_DEPENDS="dconf, gsettings-desktop-schemas, ldd, libnotify, libmatekbd, mate-applets, mate-panel, pygobject, python, python-pip, python-psutil"
TERMUX_PKG_SUGGESTS="mate-applet-brisk-menu, plank-reloaded, tilda, mate-applet-appmenu"
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_RM_AFTER_INSTALL="
local
share/polkit-1
"

termux_step_post_make_install() {
	# this software installs itself in a really messed-up directory structure.
	# The easiest way to explain what is wrong is to just show commands fixing it after installation:
	install -Dm755 -t "$TERMUX_PREFIX/bin" "$TERMUX_PREFIX/local/bin/marco-compton"
	install -Dm755 -t "$TERMUX_PREFIX/bin" "$TERMUX_PREFIX/local/bin/marco-picom"
	local prog
	for prog in marco-glx marco-no-composite marco-xr_glx_hybrid marco-xrender mate-tweak; do
		install -Dm755 -t "$TERMUX_PREFIX/bin" "$TERMUX_PREFIX/local/bin/$prog"
		install -Dm644 -t "$TERMUX_PREFIX/share/applications" "data/$prog.desktop"
		install -Dm644 -t "$TERMUX_PREFIX/share/man/man1" "data/$prog.1"
	done
	install -Dm644 -t "$TERMUX_PREFIX/lib/$TERMUX_PKG_NAME" data/mate-tweak.ui
	install -Dm644 -t "$TERMUX_PREFIX/lib/$TERMUX_PKG_NAME" util/mate-tweak-helper
}
