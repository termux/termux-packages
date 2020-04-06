TERMUX_PKG_HOMEPAGE=https://6xq.net/pianobar/
TERMUX_PKG_DESCRIPTION="pianobar is a free/open-source, console-based client for the personalized online radio Pandora."
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_VERSION=2019.02.14
TERMUX_PKG_SRCURL=https://github.com/PromyLOPh/pianobar/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=415858f8bf938a84af06b15fd49daa49fd2089f3c66f55356c0987ac4fce20d7
TERMUX_PKG_DEPENDS="libao, ffmpeg, libgcrypt, libcurl, json-c"
TERMUX_PKG_BUILD_DEPENDS="libao, ffmpeg, libgcrypt, libcurl, json-c"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_make_install(){
    #install useful script
    install -Dm755 "$TERMUX_PKG_SRCDIR"/contrib/headless_pianobar "$TERMUX_PREFIX"/bin/pianoctl
}
