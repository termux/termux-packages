TERMUX_PKG_HOMEPAGE=https://github.com/ConsoleKit2/ConsoleKit2
TERMUX_PKG_DESCRIPTION="A framework for defining and tracking users, login sessions, and seats"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
# Need the compact layer of sd_login_monitor for accountsservice
_COMMIT=c5d4aa68c27171931e401e249a84d4d4d2ce8b3c
TERMUX_PKG_VERSION="2.0.0~dev"
TERMUX_PKG_SRCURL="https://github.com/ConsoleKit2/ConsoleKit2/archive/$_COMMIT.zip"
TERMUX_PKG_SHA256=4ddee267042537488ba8868b0336ddea5f9fada05bf276617d5cb3dfb1c7cdfc
TERMUX_PKG_DEPENDS="dbus, glib"
TERMUX_PKG_BUILD_DEPENDS="glib-cross"
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--with-rundir=$TERMUX_PREFIX/var/run
--disable-polkit
--disable-libdrm
--disable-libevdev
--disable-libudev
--enable-pam-module=no
ac_cv_file__sys_class_tty_tty0_active=no
--with-systemdsystemunitdir=no
"

termux_step_pre_configure() {
	autoreconf -fi
}
