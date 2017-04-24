TERMUX_PKG_HOMEPAGE=https://weechat.org/
TERMUX_PKG_DESCRIPTION="Fast, light and extensible IRC chat client"
TERMUX_PKG_VERSION=1.7.1
TERMUX_PKG_SHA256=c0f9786cdfcf7411bfadca828c5e0819ac641717f775da804d8fa2aa69a84080
TERMUX_PKG_SRCURL=https://www.weechat.org/files/src/weechat-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_DEPENDS="ncurses, libgcrypt, libcurl, libgnutls, libandroid-support"
# weechat-curses is a symlink to weechat, so remove it:
TERMUX_PKG_RM_AFTER_INSTALL="bin/weechat-curses share/icons"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCA_FILE=$TERMUX_PREFIX/etc/tls/cert.pem
-DENABLE_LUA=ON
-DENABLE_MAN=ON
-DENABLE_PERL=ON
-DENABLE_PYTHON3=ON
-DENABLE_TCL=OFF
-DMSGFMT_EXECUTABLE=`which msgfmt`
-DMSGMERGE_EXECUTABLE=`which msgmerge`
-DPKG_CONFIG_EXECUTABLE=`which pkg-config`
-DXGETTEXT_EXECUTABLE=`which xgettext`
"
