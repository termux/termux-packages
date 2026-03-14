TERMUX_PKG_HOMEPAGE=https://wiki.gnome.org/Projects/gvfs
TERMUX_PKG_DESCRIPTION="A userspace virtual filesystem implementation for GIO"
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.60.0"
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/gvfs/${TERMUX_PKG_VERSION%.*}/gvfs-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=648273f069e92c7e3c013b92148e82c901f08044e2b3b14c6cfbd52269f6b646
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="dbus, gcr4, glib, gsettings-desktop-schemas, libarchive, libsecret, libsoup3, libxml2"
TERMUX_PKG_RECOMMENDS="gnome-keyring"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dsystemduserunitdir=no
-Dtmpfilesdir=no
-Dprivileged_group=system
-Dadmin=false
-Dafc=false
-Dafp=false
-Darchive=true
-Dcdda=false
-Ddnssd=false
-Dgoa=false
-Dgoogle=false
-Dgphoto2=false
-Dhttp=true
-Dmtp=false
-Dnfs=false
-Donedrive=false
-Dsftp=true
-Dsmb=false
-Dudisks2=false
-Dbluray=false
-Dfuse=false
-Dgcr=true
-Dgcrypt=false
-Dgudev=false
-Dlogind=false
-Dlibusb=false
"

termux_step_pre_configure() {
	termux_setup_glib_cross_pkg_config_wrapper
}
