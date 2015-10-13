TERMUX_PKG_VERSION=1.20
TERMUX_PKG_BUILD_REVISION=1
TERMUX_PKG_HOMEPAGE=http://www.gnupg.org/related_software/libgpg-error/
TERMUX_PKG_DESCRIPTION="Small library that defines common error values for all GnuPG components"
TERMUX_PKG_SRCURL=ftp://ftp.gnupg.org/gcrypt/libgpg-error/libgpg-error-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_RM_AFTER_INSTALL="share/common-lisp"

termux_step_post_configure () {
	# To fix non-arm builds, see:
	# https://lists.gnupg.org/pipermail/gnupg-devel/2014-January/028203.html
	# https://gitorious.org/vlc/vlc/commit/3054560987971aff19c496db38834458f8c29377
	cp $TERMUX_PKG_SRCDIR/src/syscfg/lock-obj-pub.arm-unknown-linux-androideabi.h $TERMUX_PKG_SRCDIR/src/syscfg/lock-obj-pub.linux-android.h
}
