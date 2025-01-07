TERMUX_PKG_HOMEPAGE=https://6xq.net/pianobar/
TERMUX_PKG_DESCRIPTION="pianobar is a free/open-source, console-based client for the personalized online radio Pandora."
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2024.12.21"
TERMUX_PKG_SRCURL=https://github.com/PromyLOPh/pianobar/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=e988dff4a4b7cc6a19e944b7516f697d7e6c41d6dc0ff25a708bcb6b92d72a89
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
TERMUX_PKG_DEPENDS="libao, ffmpeg, libgcrypt, libcurl, json-c"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_make_install(){
	#install useful script
	install -Dm755 "$TERMUX_PKG_SRCDIR"/contrib/headless_pianobar "$TERMUX_PREFIX"/bin/pianoctl
}
