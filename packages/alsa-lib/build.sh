TERMUX_PKG_HOMEPAGE=https://www.alsa-project.org
TERMUX_PKG_DESCRIPTION="The Advanced Linux Sound Architecture (ALSA) - library"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.2.13"
TERMUX_PKG_SRCURL="https://github.com/alsa-project/alsa-lib/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=e296a2e8fa165855e2c8f263ff6bc0b0ea21a3bece4404135f3a181d1a03e63a
TERMUX_PKG_DEPENDS="libandroid-sysv-semaphore, libandroid-shmem"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-static
--with-versioned=no
--with-tmpdir=$TERMUX_PREFIX/tmp
"

termux_step_pre_configure() {
	# pcm interface uses sysv semaphore which is broken on Android 14+ (issue #20514)
	# Nonetheless, it is still enabled because:
	# 1. probably never called because Android has no /dev/snd/pcm* device
	# 2. still required for other packages in compile time, e.g. pipewire-alsa
	# -landroid-shmem is for depending packages in compile time
	LDFLAGS+=" -landroid-sysv-semaphore -landroid-shmem"
	autoreconf -fi
}
