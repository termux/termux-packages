TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com> @xeffyr"

TERMUX_PKG_HOMEPAGE=http://www.gtk.org/
TERMUX_PKG_DESCRIPTION="GObject-based multi-platform GUI toolkit (legacy)"
TERMUX_PKG_VERSION=2.24.32
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://github.com/GNOME/gtk/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=961678c64ad986029befd7bdd8ed3e3849e2c5e54d24affbc7d49758245c87fa
TERMUX_PKG_DEPENDS="adwaita-icon-theme, coreutils, desktop-file-utils, glib-bin, gtk-update-icon-cache, libatk, libcairo-x, librsvg, libxcomposite, libxcursor, libxdamage, libxi, libxinerama, libxrandr, pango-x, shared-mime-info"
TERMUX_PKG_BUILD_IN_SRC=true

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-shm
--enable-xkb
--enable-xinerama
--disable-glibtest
--disable-cups
--disable-papi
--enable-introspection=no
"

## provided by libgtk3's sub package
TERMUX_PKG_RM_AFTER_INSTALL="bin/gtk-update-icon-cache"

termux_step_pre_configure() {
    NOCONFIGURE=1 ./autogen.sh
    export LIBS="-landroid-shmem"
    export LDFLAGS="${LDFLAGS} -landroid-shmem"
}

termux_step_create_debscripts()
{
    cp "${TERMUX_PKG_BUILDER_DIR}/postinst" ./
    cp "${TERMUX_PKG_BUILDER_DIR}/postrm"   ./
    cp "${TERMUX_PKG_BUILDER_DIR}/triggers" ./
}
