TERMUX_PKG_HOMEPAGE=http://xmlstar.sourceforge.net/
TERMUX_PKG_DESCRIPTION="Command line XML toolkit"
TERMUX_PKG_VERSION=1.6.1
TERMUX_PKG_SRCURL=http://downloads.sourceforge.net/project/xmlstar/xmlstarlet/${TERMUX_PKG_VERSION}/xmlstarlet-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="libxslt"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-libxml-include-prefix=${TERMUX_PREFIX}/include/libxml2 ac_cv_func_malloc_0_nonnull=yes ac_cv_func_realloc_0_nonnull=yes"
TERMUX_PKG_BUILD_IN_SRC=yes
