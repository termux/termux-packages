TERMUX_PKG_HOMEPAGE=https://crawl.develz.org/
TERMUX_PKG_DESCRIPTION="Roguelike adventure through dungeons filled with dangerous monsters"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_SRCURL=https://github.com/crawl/crawl.git
TERMUX_PKG_VERSION=0.29-a0
TERMUX_PKG_REVISION=0
TERMUX_PKG_GIT_BRANCH=0.29-a0
TERMUX_PKG_DEPENDS="ncurses, zlib"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
    export CROSSHOST="$TERMUX_HOST_PLATFORM"
    export TERMUX_PKG_BUILDDIR="$TERMUX_PKG_SRCDIR/crawl-ref/source"

    export INCLUDES_L="-I$TERMUX_PREFIX/include"
    export LIBS="-llog -Wl,--rpath=$TERMUX_PREFIX/lib"
}

termux_step_post_configure() {
    sed -i 's,#ifdef __ANDROID__,#ifdef __NO_THANKS__,g' "$TERMUX_PKG_BUILDDIR/syscalls.cc"
}
