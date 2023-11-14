TERMUX_PKG_HOMEPAGE=https://chrony-project.org/
TERMUX_PKG_DESCRIPTION="chrony is an implementation of the Network Time Protocol (NTP)"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@marek22k"
TERMUX_PKG_VERSION=4.4
TERMUX_PKG_SRCURL=https://chrony-project.org/releases/chrony-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=eafb07e6daf92b142200f478856dfed6efc9ea2d146eeded5edcb09b93127088
TERMUX_PKG_DEPENDS="readline, libtomcrypt, libnettle, libnss, libgnutls, libcap"

# chrony can currently (not yet) adjust the time on Android
# see https://gitlab.com/chrony/chrony/-/issues/1
# For the build to be successful, this functionality must be deactivated with `--disable-refclock`.
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-refclock
--prefix=\"${TERMUX_PREFIX}\"
--sysconfdir=\"${TERMUX_PREFIX}/etc\"
--localstatedir=\"${TERMUX_PREFIX}/var\"
--host-system=\"${TERMUX_ARCH}\"
"
