TERMUX_PKG_HOMEPAGE=https://www.alsa-project.org
TERMUX_PKG_DESCRIPTION="The Advanced Linux Sound Architecture (ALSA) - library"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.2.11"
TERMUX_PKG_SRCURL="https://github.com/alsa-project/alsa-lib/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=12216f0730d6dde3ded6a2a5388bc0009ad07f5c65972bd89aac9a76f8f085a4
TERMUX_PKG_DEPENDS="libandroid-sysv-semaphore, libandroid-shmem"
TERMUX_PKG_AUTO_UPDATE=true
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
