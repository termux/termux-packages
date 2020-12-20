TERMUX_PKG_HOMEPAGE=https://6xq.net/pianobar/
TERMUX_PKG_DESCRIPTION="pianobar is a free/open-source, console-based client for the personalized online radio Pandora."
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2020.11.28
TERMUX_PKG_SRCURL=https://github.com/PromyLOPh/pianobar/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=f8cdd564e2a12ee0740c54e8bc4028b328e9afb041d9ea40bcb762e08034b9e9
TERMUX_PKG_DEPENDS="libao, ffmpeg, libgcrypt, libcurl, json-c"
TERMUX_PKG_BUILD_DEPENDS="libao, ffmpeg, libgcrypt, libcurl, json-c"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_make_install(){
    #install useful script
    install -Dm755 "$TERMUX_PKG_SRCDIR"/contrib/headless_pianobar "$TERMUX_PREFIX"/bin/pianoctl
}
