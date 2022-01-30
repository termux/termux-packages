TERMUX_PKG_HOMEPAGE=https://weechat.org/
TERMUX_PKG_DESCRIPTION="Fast, light and extensible IRC chat client"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.0.1
TERMUX_PKG_REVISION=7
TERMUX_PKG_SRCURL=https://www.weechat.org/files/src/weechat-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=63ac24c41e88798ad48bfbe8a7e1fd56ddf24416f86bccd3a53b258a569ca038
TERMUX_PKG_DEPENDS="libiconv, ncurses, libgcrypt, libcurl, libgnutls, libandroid-support, zlib"
TERMUX_PKG_BREAKS="weechat-dev"
TERMUX_PKG_REPLACES="weechat-dev"
TERMUX_PKG_RM_AFTER_INSTALL="bin/weechat-curses share/man/man1/weechat-headless.1 share/icons"

# Ruby 3.x is not supported as of weechat 3.0.1.
#-- Checking for one of the modules 'ruby-2.7;ruby-2.6;ruby-2.5;ruby-2.4;ruby-2.3;ruby-2.2;ruby-2.1;ruby-2.0;ruby-1.9'
#CMake Error at src/plugins/CMakeLists.txt:116 (message):
#  Ruby not found
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCA_FILE=$TERMUX_PREFIX/etc/tls/cert.pem
-DENABLE_HEADLESS=OFF
-DENABLE_LUA=ON
-DENABLE_MAN=ON
-DENABLE_PERL=ON
-DENABLE_PYTHON3=ON
-DENABLE_TCL=OFF
-DENABLE_PHP=OFF
-DENABLE_RUBY=OFF
-DENABLE_JAVASCRIPT=OFF
-DENABLE_GUILE=OFF
-DENABLE_SPELL=OFF
-DENABLE_TESTS=OFF
-DSTRICT=ON
-DMSGFMT_EXECUTABLE=$(command -v msgfmt)
-DMSGMERGE_EXECUTABLE=$(command -v msgmerge)
-DXGETTEXT_EXECUTABLE=$(command -v xgettext)
"

termux_step_pre_configure() {
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DPKG_CONFIG_EXECUTABLE=$PKG_CONFIG"
}
