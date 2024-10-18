TERMUX_PKG_HOMEPAGE=https://wiki.gnome.org/Projects/gvfs
TERMUX_PKG_DESCRIPTION="A userspace virtual filesystem implementation for GIO"
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.55.1"
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/gvfs/${TERMUX_PKG_VERSION%.*}/gvfs-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=684a45844d0f0b35757f06d8e636b11801f95e956cc85d6ec57d85ba68de80a7
TERMUX_PKG_DEPENDS="dbus, gcr4, glib, gsettings-desktop-schemas, libarchive, libsoup3, libxml2"
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
-Dkeyring=false
-Dlogind=false
-Dlibusb=false
"

termux_step_pre_configure() {
	termux_setup_glib_cross_pkg_config_wrapper
}
