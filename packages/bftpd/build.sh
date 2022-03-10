TERMUX_PKG_HOMEPAGE=http://bftpd.sourceforge.net/
TERMUX_PKG_DESCRIPTION="Small, easy-to-configure FTP server"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=6.1
TERMUX_PKG_SRCURL=https://kumisystems.dl.sourceforge.net/project/bftpd/bftpd/bftpd-${TERMUX_PKG_VERSION}/bftpd-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=9721d0614e1a5d0fe6b80c9a8a04ada8efd42cbdfddd239e95a8059ae283aa6f
TERMUX_PKG_DEPENDS="libcrypt"
TERMUX_PKG_BUILD_IN_SRC=true

TERMUX_PKG_CONFFILES="etc/bftpd.conf"
TERMUX_PKG_RM_AFTER_INSTALL="var/log/bftpd.log"

termux_step_pre_configure() {
	CFLAGS+=" -fcommon"
}
