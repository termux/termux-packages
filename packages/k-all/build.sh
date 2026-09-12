# Termux Package Build Recipe for k-all
TERMUX_PKG_NAME=k-all
TERMUX_PKG_VERSION=0.1.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_DESCRIPTION="A CLI K-Pop App where you can listen to music, read news, and more"
TERMUX_PKG_HOMEPAGE="https://github.com/Finalliery/k-all"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Finalliery <embedlo5474@hotmail.com>"

# 🔗 Pulls your pre-compiled mobile package directly from your GitHub Release stream
TERMUX_PKG_SRCURL=https://github.com/releases/download/v0.1.0-alpha/k-all_0.1.0_termux.tar.gz
# 💡 Put your .tar.gz file's SHA-256 hash here so Termux can verify it securely
TERMUX_PKG_SHA256=c814ddcee6248c45f62d326a8e58342f07b94a7bded45f255eb214d21087e522

# 🛠️ Structural audio and video streaming dependencies
TERMUX_PKG_DEPENDS="mpv, yt-dlp"

termux_step_make_install() {
	# Unpacks your pre-built ARM64 structure cleanly into the Termux mobile system root
	dpkg-deb -x $TERMUX_PKG_SRCDIR/k-all_0.1.0_termux_arm64.deb $TERMUX_PREFIX/../
}
