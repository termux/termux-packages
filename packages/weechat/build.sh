TERMUX_PKG_HOMEPAGE=https://weechat.org/
TERMUX_PKG_DESCRIPTION="Fast, light and extensible IRC chat client"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
# `weechat-python-plugin` depends on libpython${TERMUX_PYTHON_VERSION}.so.
# Please revbump and rebuild when bumping TERMUX_PYTHON_VERSION.
TERMUX_PKG_VERSION="3.8"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_SRCURL=https://www.weechat.org/files/src/weechat-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=a1b8f10141af0614e46d09781ac8433f746c0a4016e33f75ecbf56c9a568623e
TERMUX_PKG_DEPENDS="libiconv, ncurses, libgcrypt, libcurl, libgnutls, libandroid-support, zlib, zstd"
TERMUX_PKG_BREAKS="weechat-dev"
TERMUX_PKG_REPLACES="weechat-dev"
TERMUX_PKG_RM_AFTER_INSTALL="bin/weechat-curses share/man/man1/weechat-headless.1 share/icons"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCA_FILE=$TERMUX_PREFIX/etc/tls/cert.pem
-DENABLE_HEADLESS=OFF
-DENABLE_LUA=ON
-DENABLE_MAN=ON
-DENABLE_PERL=ON
-DENABLE_PYTHON3=ON
-DENABLE_TCL=OFF
-DENABLE_PHP=OFF
-DENABLE_RUBY=ON
-DENABLE_JAVASCRIPT=OFF
-DENABLE_GUILE=OFF
-DENABLE_SPELL=OFF
-DENABLE_TESTS=OFF
-DSTRICT=ON
-DMSGFMT_EXECUTABLE=$(command -v msgfmt)
-DMSGMERGE_EXECUTABLE=$(command -v msgmerge)
-DXGETTEXT_EXECUTABLE=$(command -v xgettext)
-DLIBGCRYPT_CONFIG_EXECUTABLE=$TERMUX_PREFIX/bin/libgcrypt-config
"

termux_step_pre_configure() {
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DPKG_CONFIG_EXECUTABLE=$PKG_CONFIG"
}
