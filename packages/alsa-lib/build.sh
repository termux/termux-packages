TERMUX_PKG_HOMEPAGE=https://www.alsa-project.org
TERMUX_PKG_DESCRIPTION="The Advanced Linux Sound Architecture (ALSA) - library"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.2.11"
TERMUX_PKG_SRCURL="https://github.com/alsa-project/alsa-lib/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=12216f0730d6dde3ded6a2a5388bc0009ad07f5c65972bd89aac9a76f8f085a4
TERMUX_PKG_DEPENDS="libandroid-sysv-semaphore"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-static
--with-versioned=no
"

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-sysv-semaphore"
	autoreconf -fi
}
