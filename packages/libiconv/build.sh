TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/libiconv/
TERMUX_PKG_DESCRIPTION="An implementation of iconv()"
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_VERSION=1.16
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://ftp.gnu.org/pub/gnu/libiconv/libiconv-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=e6a1b1b589654277ee790cce3734f07876ac4ccfaecbee8afa0b649cf529cc04
TERMUX_PKG_BREAKS="libandroid-support (<= 24), libiconv-dev"
TERMUX_PKG_REPLACES="libandroid-support (<= 24), libiconv-dev"

# Enable extra encodings (such as CP437) needed by some programs:
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-extra-encodings"
