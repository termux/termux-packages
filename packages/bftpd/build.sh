TERMUX_PKG_HOMEPAGE=https://bftpd.sourceforge.net/
TERMUX_PKG_DESCRIPTION="Small, easy-to-configure FTP server"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.2"
TERMUX_PKG_SRCURL=https://kumisystems.dl.sourceforge.net/project/bftpd/bftpd/bftpd-${TERMUX_PKG_VERSION}/bftpd-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=959185b1457a2cd8e404d52957d51879d56dd72b75a93049528af11ade00a6c2
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libcrypt"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--mandir=$TERMUX_PREFIX/share/man
"

TERMUX_PKG_CONFFILES="etc/bftpd.conf"
TERMUX_PKG_RM_AFTER_INSTALL="var/log/bftpd.log"

termux_step_pre_configure() {
	CFLAGS+=" -fcommon"
}
