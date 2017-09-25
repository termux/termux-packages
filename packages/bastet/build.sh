TERMUX_PKG_HOMEPAGE=http://fph.altervista.org/prog/bastet.html
TERMUX_PKG_DESCRIPTION="ncurses-based brick game"
TERMUX_PKG_DEPENDS="ncurses, ncurses-ui-libs, ncurses-dev, ncurses-utils"
TERMUX_PKG_VERSION=0.43.2
TERMUX_PKG_SRCURL=https://github.com/fph/bastet/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=f219510afc1d83e4651fbffd5921b1e0b926d5311da4f8fa7df103dc7f2c403f
TERMUX_PKG_BUILD_IN_SRC="yes"

termux_step_post_configure () {
     cd $TERMUX_PKG_SRCDIR
     sed '/include_next <utility>/d' -i /data/data/com.termux/files/usr/include/boost/tr1/detail/config_all.hpp
     
} 
termux_step_post_make_install () {
     cd $TERMUX_PKG_SRCDIR
     mv bastet $TERMUX_PREFIX
} 
