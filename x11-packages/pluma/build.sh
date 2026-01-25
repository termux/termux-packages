TERMUX_PKG_HOMEPAGE=https://mate-desktop.org/
TERMUX_PKG_DESCRIPTION="Powerful text editor for MATE"
TERMUX_PKG_LICENSE="GPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.28.0"
TERMUX_PKG_SRCURL="https://github.com/mate-desktop/pluma/releases/download/v$TERMUX_PKG_VERSION/pluma-$TERMUX_PKG_VERSION.tar.xz"
TERMUX_PKG_SHA256=aa8adf9589345093a50e30b27ede4a78a2421d1727c27f465fc87c435965a1d4
# version 1.28.1 has a build failure not only in Termux, but also the same error in upstream's own CI;
# wait for them to fix it
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_DEPENDS="iso-codes, mate-desktop, zenity, gtksourceview4, glib, gobject-introspection, libpeas, gettext, enchant, libsm"
TERMUX_PKG_SUGGESTS="pygobject"
TERMUX_PKG_BUILD_DEPENDS="autoconf-archive, mate-common"
# the python plugins do not work because of a libpeas-related dependency conflict
# if upstream fixes that in the future, enable python in libpeas to resolve this
# (enabling python in libpeas will not resolve this
# until upstream pluma and/or libpeas and/or python-gobject fixes this problem)
# (setting --disable-python does not seem to hide the broken python plugins from the user,
# so there is no point to disabling python in pluma)
# More information:
# https://gitlab.archlinux.org/archlinux/packaging/packages/libpeas/-/commit/75310ec6c665e4104044b996e26b34c4ab169b2d
# https://gitlab.archlinux.org/archlinux/packaging/packages/pygobject/-/issues/3
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-python
"

termux_step_pre_configure() {
	termux_setup_gir
	termux_setup_glib_cross_pkg_config_wrapper
}
