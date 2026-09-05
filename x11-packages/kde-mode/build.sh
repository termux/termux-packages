TERMUX_PKG_HOMEPAGE="https://github.com/wlpne/kde-mode"
TERMUX_PKG_DESCRIPTION="CLI session manager for running KDE Plasma in Termux:X11"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="wlpne <wlpne@github>"
TERMUX_PKG_VERSION="1.0.0"
TERMUX_PKG_DEPENDS="plasma-desktop, termux-x11-nightly, dbus, pulseaudio, coreutils, tsu"
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_SKIP_SRC_EXTRACT=true

termux_step_get_source() {
    mkdir -p "$TERMUX_PKG_SRCDIR"
    cp -a "$TERMUX_PKG_BUILDER_DIR"/* "$TERMUX_PKG_SRCDIR/"
}

termux_step_make_install() {
    install -Dm755 "$TERMUX_PKG_SRCDIR/kde-mode" "$TERMUX_PREFIX/bin/kde-mode"
}
