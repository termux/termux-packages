TERMUX_PKG_HOMEPAGE=http://www.harding.motd.ca/autossh/
TERMUX_PKG_DESCRIPTION="Automatically restart SSH sessions and tunnels"
TERMUX_PKG_VERSION=1.4f
TERMUX_PKG_SHA256=f47fe281a840e00a141204ad9cc54a9ebfb5af8235a45a3f25b14184934f05af
TERMUX_PKG_SRCURL=https://fossies.org/linux/privat/autossh-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_BUILD_IN_SRC="yes"
TERMUX_PKG_DEPENDS="openssh"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--mandir=$TERMUX_PREFIX/share/man ac_cv_path_ssh=$TERMUX_PREFIX/bin/ssh"

termux_step_pre_configure () {
	# For syslog logging:
	LDFLAGS+=" -llog"
}
