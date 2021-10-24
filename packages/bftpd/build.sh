TERMUX_PKG_HOMEPAGE=http://bftpd.sourceforge.net/
TERMUX_PKG_DESCRIPTION="Small, easy-to-configure FTP server"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Leonid Pliushch <leonid.pliushch@gmail.com>"
TERMUX_PKG_VERSION=5.7
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://kumisystems.dl.sourceforge.net/project/bftpd/bftpd/bftpd-${TERMUX_PKG_VERSION}/bftpd-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=a543ce62a8092a7b5065146875cc9878534b09dc4a853f2c2b56e2de397a6f4b
TERMUX_PKG_DEPENDS="libcrypt"
TERMUX_PKG_BUILD_IN_SRC=true

TERMUX_PKG_CONFFILES="etc/bftpd.conf"
TERMUX_PKG_RM_AFTER_INSTALL="var/log/bftpd.log"

termux_step_pre_configure() {
	CFLAGS+=" -fcommon"
}
