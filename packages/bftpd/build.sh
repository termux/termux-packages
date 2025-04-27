TERMUX_PKG_HOMEPAGE=https://bftpd.sourceforge.net/
TERMUX_PKG_DESCRIPTION="Small, easy-to-configure FTP server"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.3"
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/sourceforge/bftpd/bftpd-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=7fb5d9092ac6c2642ac9fe42e31b49e3a4384831f16ebd79ac3cdc00ad4fbc1e
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
