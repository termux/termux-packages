TERMUX_PKG_HOMEPAGE=http://tinyscheme.sourceforge.net/home.html
TERMUX_PKG_DESCRIPTION="Very small scheme implementation"
TERMUX_PKG_VERSION=1.41
TERMUX_PKG_SRCURL=http://downloads.sourceforge.net/project/tinyscheme/tinyscheme/tinyscheme-1.41/tinyscheme-1.41.tar.gz
TERMUX_PKG_BUILD_IN_SRC=yes
# TERMUX_PKG_DEPENDS="pcre, openssl, libuuid"
# TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-ssl=openssl --disable-iri"

AR+=" crs"
LD=$CC

# TODO: Add the tsx extension with file/networking (http://heras-gilsanz.com/manuel/tsx.html)
#       and the regexp extension (http://downloads.sourceforge.net/project/tinyscheme/tinyscheme-regex/1.3/re-1.3.tar.gz)
#termux_step_pre_make () {
#TSX_TARFILE=$TERMUX_PKG_CACHEDIR/tsx-1.1.tar.gz
#test ! -f $TSX_TARFILE && curl -o $TSX_TARFILE "http://heras-gilsanz.com/manuel/tsx-1.1.tgz"
#}
