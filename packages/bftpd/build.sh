TERMUX_PKG_HOMEPAGE=https://bftpd.sourceforge.net/
TERMUX_PKG_DESCRIPTION="Small, easy-to-configure FTP server"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.7"
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/sourceforge/bftpd/bftpd-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=40317957c3667fded7541ff4b0f44328573827ef0315519a44ca1b627f5eafb2
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
