TERMUX_PKG_HOMEPAGE=https://rpm.org/
TERMUX_PKG_DESCRIPTION="RPM Package Manager"
TERMUX_PKG_LICENSE="GPL-2.0, LGPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=6.1.0
TERMUX_PKG_SRCURL="https://ftp.osuosl.org/pub/rpm/releases/rpm-${TERMUX_PKG_VERSION%.*}.x/rpm-${TERMUX_PKG_VERSION}.tar.bz2"
TERMUX_PKG_SHA256=f520810d27c74bf1c5d8b8885845c61e0c845f62d33e68b02e020633a8b62fe3
TERMUX_PKG_DEPENDS="libandroid-glob, libandroid-spawn, libarchive, libbz2, libgcrypt, libiconv, liblzma, libmagic, libpopt, libsqlite, lua54, readline, zlib, zstd"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DENABLE_OPENMP=OFF
-DENABLE_PYTHON=OFF
-DWITH_CAP=OFF
-DWITH_ACL=OFF
-DWITH_SELINUX=OFF
-DWITH_DBUS=OFF
-DWITH_AUDIT=OFF
-DWITH_FAPOLICYD=OFF
-DWITH_SEQUOIA=OFF
-DWITH_LIBDW=OFF
-DWITH_LIBELF=OFF
-DLUA_INCLUDE_DIR=$TERMUX_PREFIX/include/lua5.4
-DLUA_LIBRARY=$TERMUX_PREFIX/lib/liblua5.4.so
-DSCDOC=$(command -v scdoc)
"

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-glob -landroid-spawn $($CC -print-libgcc-file-name)"
}
