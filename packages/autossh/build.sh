TERMUX_PKG_HOMEPAGE=http://www.harding.motd.ca/autossh/
TERMUX_PKG_DESCRIPTION="Automatically restart SSH sessions and tunnels"
TERMUX_PKG_VERSION=1.4e
TERMUX_PKG_SHA256=4425cb42deb03dfb97790d3c301d1703b3cd781ea00808ed20fc663bcc06e57f
TERMUX_PKG_SRCURL=https://fossies.org/linux/privat/autossh-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_BUILD_IN_SRC="yes"
TERMUX_PKG_DEPENDS="openssh"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--mandir=$TERMUX_PREFIX/share/man ac_cv_path_ssh=$TERMUX_PREFIX/bin/ssh"

termux_step_pre_configure () {
	# For syslog logging:
	LDFLAGS+=" -llog"
}
