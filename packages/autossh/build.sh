TERMUX_PKG_HOMEPAGE=http://www.harding.motd.ca/autossh/
TERMUX_PKG_DESCRIPTION="Automatically restart SSH sessions and tunnels"
TERMUX_PKG_VERSION=1.4e
TERMUX_PKG_SRCURL=http://www.harding.motd.ca/autossh/autossh-${TERMUX_PKG_VERSION}.tgz
TERMUX_PKG_SHA256=9e8e10a59d7619176f4b986e256f776097a364d1be012781ea52e08d04679156
TERMUX_PKG_BUILD_IN_SRC="yes"
TERMUX_PKG_DEPENDS="openssh"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--mandir=$TERMUX_PREFIX/share/man ac_cv_path_ssh=$TERMUX_PREFIX/bin/ssh"

termux_step_pre_configure () {
	# For syslog logging:
	LDFLAGS+=" -llog"
}
