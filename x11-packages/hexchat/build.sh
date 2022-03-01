TERMUX_PKG_HOMEPAGE=https://hexchat.github.io/
TERMUX_PKG_DESCRIPTION="A popular and easy to use graphical IRC (chat) client"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.14.3
TERMUX_PKG_REVISION=23
TERMUX_PKG_SRCURL=https://github.com/hexchat/hexchat/archive/v2.14.2.tar.gz
TERMUX_PKG_SHA256=4f2c2137020913513ea559f788c41039ca6230764d8158862d5d1ee8785592d9
TERMUX_PKG_DEPENDS="gdk-pixbuf, glib, gtk2, liblua53, libnotify, libx11, openssl, pango, python"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dwith-libproxy=false
-Dwith-libcanberra=false
-Dwith-dbus=false
-Dwith-lua=lua53
-Dwith-text=true
-Dwith-perl=false
-Dwith-sysinfo=false
"

TERMUX_PKG_RM_AFTER_INSTALL="share/locale"

termux_step_post_make_install() {
	## TODO: patch it to force link with libandroid-shmem instead of
	## using wrapper.
	mkdir -p "${TERMUX_PREFIX}/libexec/"
	mv "${TERMUX_PREFIX}/bin/hexchat" "${TERMUX_PREFIX}/libexec/"
	sed "s|@TERMUX_PREFIX@|${TERMUX_PREFIX}|g" \
		"${TERMUX_PKG_BUILDER_DIR}/hexchat.in" > "${TERMUX_PREFIX}/bin/hexchat"
	chmod 700 "${TERMUX_PREFIX}/bin/hexchat"
}
