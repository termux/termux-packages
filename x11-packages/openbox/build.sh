TERMUX_PKG_HOMEPAGE=http://openbox.org
TERMUX_PKG_DESCRIPTION="Highly configurable and lightweight X11 window manager"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.6.1
TERMUX_PKG_REVISION=58
TERMUX_PKG_SRCURL=http://openbox.org/dist/openbox/openbox-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=8b4ac0760018c77c0044fab06a4f0c510ba87eae934d9983b10878483bde7ef7
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-session-management"
TERMUX_PKG_DEPENDS="bash, fontconfig, freetype, gdk-pixbuf, glib, harfbuzz, imlib2, libcairo, libice, librsvg, libsm, libx11, libxcursor, libxext, libxft, libxinerama, libxml2, libxrandr, libxrender, pango, startup-notification"

# Configuration utility.
TERMUX_PKG_RECOMMENDS="obconf-qt"

# For default menu entries.
TERMUX_PKG_SUGGESTS="aterm, fltk, geany, the-powder-toy, dosbox"

TERMUX_PKG_RM_AFTER_INSTALL="
bin/gdm-control
bin/gnome-panel-control
bin/openbox-gnome-session
bin/openbox-kde-session
share/man/man1/openbox-gnome-session.1
share/man/man1/openbox-kde-session.1
share/gnome-session
share/gnome
share/xsessions/openbox-gnome.desktop
share/xsessions/openbox-kde.desktop
"

TERMUX_PKG_CONFFILES="
etc/xdg/openbox/autostart
etc/xdg/openbox/environment
etc/xdg/openbox/menu.xml
etc/xdg/openbox/rc.xml
"

termux_step_post_make_install() {
	## install custom variant of scripts startup scripts
	cp -f "${TERMUX_PKG_BUILDER_DIR}/scripts/openbox-session" "${TERMUX_PREFIX}/bin/openbox-session"
	sed -i "s|@TERMUX_PREFIX@|$TERMUX_PREFIX|g" "${TERMUX_PREFIX}/bin/openbox-session"
	chmod 755 "${TERMUX_PREFIX}/bin/openbox-session"

	cp -f "${TERMUX_PKG_BUILDER_DIR}/scripts/openbox-autostart" "${TERMUX_PREFIX}/libexec/openbox-autostart"
	sed -i "s|@TERMUX_PREFIX@|$TERMUX_PREFIX|g" "${TERMUX_PREFIX}/libexec/openbox-autostart"
	chmod 755 "${TERMUX_PREFIX}/libexec/openbox-autostart"

	cp -f "${TERMUX_PKG_BUILDER_DIR}/scripts/openbox-xdg-autostart" "${TERMUX_PREFIX}/libexec/openbox-xdg-autostart"
	sed -i "s|@TERMUX_PREFIX@|$TERMUX_PREFIX|g" "${TERMUX_PREFIX}/libexec/openbox-xdg-autostart"
	chmod 755 "${TERMUX_PREFIX}/libexec/openbox-xdg-autostart"

	## install custom config files
	cp -f "${TERMUX_PKG_BUILDER_DIR}/configs/autostart" "${TERMUX_PREFIX}/etc/xdg/openbox/autostart"
	chmod 755 "${TERMUX_PREFIX}/etc/xdg/openbox/autostart"

	cp -f "${TERMUX_PKG_BUILDER_DIR}/configs/environment" "${TERMUX_PREFIX}/etc/xdg/openbox/environment"
	chmod 755 "${TERMUX_PREFIX}/etc/xdg/openbox/environment"

	cp -f "${TERMUX_PKG_BUILDER_DIR}/configs/menu.xml" "${TERMUX_PREFIX}/etc/xdg/openbox/menu.xml"
	chmod 644 "${TERMUX_PREFIX}/etc/xdg/openbox/menu.xml"

	cp -f "${TERMUX_PKG_BUILDER_DIR}/configs/rc.xml" "${TERMUX_PREFIX}/etc/xdg/openbox/rc.xml"
	chmod 644 "${TERMUX_PREFIX}/etc/xdg/openbox/rc.xml"

	## install theme 'Onyx-Black'
	cp -a "${TERMUX_PKG_BUILDER_DIR}/Theme-Onyx-Black" "${TERMUX_PREFIX}/share/themes/Onyx-black"
	find "${TERMUX_PREFIX}/share/themes/Onyx-black" -type d | xargs chmod 755
	find "${TERMUX_PREFIX}/share/themes/Onyx-black" -type f | xargs chmod 644
}
