TERMUX_PKG_HOMEPAGE=https://steghide.sourceforge.net/
TERMUX_PKG_DESCRIPTION="Embeds a message in a file by replacing some of the least significant bits"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.5.1
TERMUX_PKG_REVISION=7
TERMUX_PKG_SRCURL=http://downloads.sourceforge.net/steghide/steghide-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=78069b7cfe9d1f5348ae43f918f06f91d783c2b3ff25af021e6a312cf541b47b
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_DEPENDS="libc++, libjpeg-turbo, libmcrypt, libmhash, zlib"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_file__dev_random=yes
ac_cv_file__dev_urandom=yes
--mandir=$TERMUX_PREFIX/share/man
"
