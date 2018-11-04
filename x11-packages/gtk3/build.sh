TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com> @xeffyr"

TERMUX_PKG_HOMEPAGE=http://www.gtk.org/
TERMUX_PKG_DESCRIPTION="GObject-based multi-platform GUI toolkit"
TERMUX_PKG_VERSION=3.24.1
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://github.com/GNOME/gtk/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=3dd9a8d52e6832e9294182c3a9d3b3979e9593db181101476323241ae67b4a44
TERMUX_PKG_BUILD_IN_SRC=true

TERMUX_PKG_DEPENDS="adwaita-icon-theme, atk, coreutils, desktop-file-utils, gdk-pixbuf, glib, glib-bin, gtk-update-icon-cache, libcairo-x, libepoxy, libxcomposite, libxcursor, libxdamage, libxfixes, libxi, libxinerama, libxrandr, pango-x, shared-mime-info"
TERMUX_PKG_BUILD_DEPENDS="xorgproto"
TERMUX_PKG_DEVPACKAGE_DEPENDS="xorgproto, pango-x-dev"
TERMUX_PKG_CONFLICTS="libgtk3"
TERMUX_PKG_REPLACES="libgtk3"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-introspection
--enable-xinerama
--enable-xfixes
--enable-xcomposite
--enable-xdamage
"

TERMUX_PKG_RM_AFTER_INSTALL="share/glib-2.0/schemas/gschemas.compiled"

termux_step_pre_configure() {
    # prevent permission denied on build scripts
    find . -type f | xargs chmod u+x
}

termux_step_create_debscripts() {
    for i in postinst postrm triggers; do
        sed \
            "s|@TERMUX_PREFIX@|${TERMUX_PREFIX}|g" \
            "${TERMUX_PKG_BUILDER_DIR}/hooks/${i}.in" > ./${i}
        chmod 755 ./${i}
    done
    unset i
    chmod 644 ./triggers
}
