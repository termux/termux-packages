TERMUX_PKG_HOMEPAGE=http://steghide.sourceforge.net/
TERMUX_PKG_DESCRIPTION="Embeds a message in a file by replacing some of the least significant bits"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
TERMUX_PKG_VERSION=0.5.1
TERMUX_PKG_REVISION=4
TERMUX_PKG_SRCURL=http://downloads.sourceforge.net/steghide/steghide-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=78069b7cfe9d1f5348ae43f918f06f91d783c2b3ff25af021e6a312cf541b47b
TERMUX_PKG_DEPENDS="libjpeg-turbo, libmcrypt, libmhash, zlib"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_file__dev_random=yes
ac_cv_file__dev_urandom=yes
--mandir=$TERMUX_PREFIX/share/man
"
