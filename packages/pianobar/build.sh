TERMUX_PKG_HOMEPAGE=https://6xq.net/pianobar/
TERMUX_PKG_DESCRIPTION="pianobar is a free/open-source, console-based client for the personalized online radio Pandora."
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_VERSION=2020.04.05
TERMUX_PKG_SRCURL=https://github.com/PromyLOPh/pianobar/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=cb319b56ee4163ac040be1844e04de37f94d8e8b058f3bf9500ed380fe385883
TERMUX_PKG_DEPENDS="libao, ffmpeg, libgcrypt, libcurl, json-c"
TERMUX_PKG_BUILD_DEPENDS="libao, ffmpeg, libgcrypt, libcurl, json-c"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_make_install(){
    #install useful script
    install -Dm755 "$TERMUX_PKG_SRCDIR"/contrib/headless_pianobar "$TERMUX_PREFIX"/bin/pianoctl
}
